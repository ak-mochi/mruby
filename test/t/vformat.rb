def sclass(v)
  class << v
    self
  end
end

assert('mrb_vformat') do
  vf = TestVFormat
  assert_equal '', vf.z('')
  assert_equal 'No specifier!', vf.z('No specifier!')
  assert_equal '`c`: C', vf.c('`c`: %c', ?C)
  assert_equal '`d`: 123', vf.d('`d`: %d', 123)
  assert_equal '`d`: -79', vf.d('`d`: %d', -79)
  assert_equal '`i`: 514', vf.i('`i`: %i', 514)
  assert_equal '`i`: -83', vf.i('`i`: %i', -83)
  assert_equal '`t`: NilClass', vf.v('`t`: %t', nil)
  assert_equal '`t`: FalseClass', vf.v('`t`: %t', false)
  assert_equal '`t`: TrueClass', vf.v('`t`: %t', true)
  assert_equal '`t`: Integer', vf.v('`t`: %t', 0)
  assert_equal '`t`: Hash', vf.v('`t`: %t', {k: "value"})
  assert_match '#<Class:#<Class:#<Hash:0x*>>>', vf.v('%t', sclass({}))
  assert_equal 'string and length', vf.l('string %l length', 'andante', 3)
  assert_equal '`n`: sym', vf.n('`n`: %n', :sym)
  assert_equal '%C文字列%', vf.s('%s', '%C文字列%')
  assert_equal '`C`: Kernel module', vf.C('`C`: %C module', Kernel)
  assert_equal '`C`: NilClass', vf.C('`C`: %C', nil.class)
  assert_match '#<Class:#<String:0x*>>', vf.C('%C', sclass(""))
  assert_equal '`T`: NilClass', vf.v('`T`: %T', nil)
  assert_equal '`T`: FalseClass', vf.v('`T`: %T', false)
  assert_equal '`T`: TrueClass', vf.v('`T`: %T', true)
  assert_equal '`T`: Integer', vf.v('`T`: %T', 0)
  assert_equal '`T`: Hash', vf.v('`T`: %T', {k: "value"})
  assert_match 'Class', vf.v('%T', sclass({}))
  assert_equal '`Y`: nil', vf.v('`Y`: %Y', nil)
  assert_equal '`Y`: false', vf.v('`Y`: %Y', false)
  assert_equal '`Y`: true', vf.v('`Y`: %Y', true)
  assert_equal '`Y`: Integer', vf.v('`Y`: %Y', 0)
  assert_equal '`Y`: Hash', vf.v('`Y`: %Y', {k: "value"})
  assert_equal 'Class', vf.v('%Y', sclass({}))
  assert_match '#<Class:#<String:0x*>>', vf.v('%v', sclass(""))
  assert_equal '`v`: 1...3', vf.v('`v`: %v', 1...3)
  assert_equal '`S`: {:a => 1, "b" => "c"}', vf.v('`S`: %S', {a: 1, "b" => ?c})
  assert_equal 'percent: %', vf.z('percent: %%')
  assert_equal '"I": inspect char', vf.c('%!c: inspect char', ?I)
  assert_equal '709: inspect mrb_int', vf.i('%!d: inspect mrb_int', 709)
  assert_equal '"a\x00b\xff"', vf.l('%!l', "a\000b\xFFc\000d", 4)
  assert_equal ':"&.": inspect symbol', vf.n('%!n: inspect symbol', :'&.')
  assert_equal 'inspect "String"', vf.v('inspect %!v', 'String')
  assert_equal 'inspect Array: [1, :x, {}]', vf.v('inspect Array: %!v', [1,:x,{}])
  assert_match '`!C`: #<Class:0x*>', vf.C('`!C`: %!C', Class.new)
  assert_equal 'escape: \\%a,b,c,d', vf.v('escape: \\\\\%a,b,\c%v', ',d')

  skip unless Object.const_defined?(:Float)
  assert_equal '`f`: 0.0125', vf.f('`f`: %f', 0.0125)
  assert_equal '-Infinity', vf.f('%f', -Float::INFINITY)
  assert_equal 'NaN: Not a Number', vf.f('%f: Not a Number', Float::NAN)
end
