const assert = require('node:assert/strict')
const fs = require('node:fs')
const path = require('node:path')
const YAML = require('yaml')

const cache = new Map()

function load (file) {
  const absolute = path.resolve(file)
  if (cache.has(absolute)) return cache.get(absolute)

  const data = YAML.parse(fs.readFileSync(absolute, 'utf8'))
  const context = { data, imports: [] }
  cache.set(absolute, context)
  context.imports = (data.meta.imports || []).map(name =>
    load(path.resolve(path.dirname(absolute), `${name}.ksy`)))
  return context
}

function resolve (context, name) {
  const parts = name.split('::')
  if (parts.length === 2) {
    const imported = context.imports.find(item => item.data.meta.id === parts[0])
    assert.ok(imported, `missing import ${parts[0]}`)
    return resolve(imported, parts[1])
  }
  if (context.data.types?.[name]) return [context, context.data.types[name]]
  if (context.data.meta.id === name) return [context, context.data]
  for (const imported of context.imports) {
    if (imported.data.meta.id === name) return [imported, imported.data]
  }
  throw new Error(`cannot resolve Kaitai type ${name} from ${context.data.meta.id}`)
}

function fixedSize (field, context) {
  let size
  if (Number.isInteger(field.size)) {
    size = field.size
  } else if (typeof field.contents === 'string') {
    size = Buffer.byteLength(field.contents, 'ascii')
  } else if (typeof field.type === 'object') {
    const sizes = Object.values(field.type.cases).map(name =>
      fixedSize({ type: name }, context))
    assert.ok(sizes.length, 'empty type switch')
    assert.ok(sizes.every(value => value === sizes[0]), 'type switch has variable-size cases')
    size = sizes[0]
  } else if (/^[us][1248]$|^f[48]$/.test(field.type)) {
    size = Number(field.type.slice(1))
  } else {
    const [owner, definition] = resolve(context, field.type)
    size = definition.seq.reduce((sum, child) => sum + fixedSize(child, owner), 0)
  }

  if (field.repeat) {
    assert.equal(field.repeat, 'expr', 'unsupported Kaitai repeat')
    assert.ok(Number.isInteger(field['repeat-expr']), 'nonconstant Kaitai repeat')
    size *= field['repeat-expr']
  }
  return size
}

function sequenceLayout (fields, context, start) {
  let offset = start
  return fields.map(field => {
    const size = fixedSize(field, context)
    const entry = { id: field.id, from: offset, size }
    offset += size
    return entry
  })
}

module.exports = { load, fixedSize, sequenceLayout, resolve }
