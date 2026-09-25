const assert = require('node:assert/strict')
const test = require('node:test')
const { fixedSize, sequenceLayout } = require('./ksy-layout')

const context = {
  data: {
    meta: { id: 'test' },
    types: {
      small: { seq: [{ id: 'value', type: 'u1' }] },
      large: { seq: [{ id: 'value', type: 'u2' }] }
    }
  },
  imports: []
}

test('fixed Kaitai fields and repeats advance documented offsets', () => {
  assert.deepEqual(sequenceLayout([
    { id: 'first', type: 'u1' },
    { id: 'values', type: 'small', repeat: 'expr', 'repeat-expr': 3 },
    { id: 'last', size: 4 }
  ], context, 14), [
    { id: 'first', from: 14, size: 1 },
    { id: 'values', from: 15, size: 3 },
    { id: 'last', from: 18, size: 4 }
  ])
})

test('variable-size switch is rejected', () => {
  assert.throws(() => fixedSize({ type: {
    cases: { one: 'small', two: 'large' }
  } }, context), /variable-size cases/)
})
