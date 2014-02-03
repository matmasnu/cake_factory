require 'matrix'
require 'rspec'

class CakeFactory
  attr_accessor :cake_model, :cake_size, :masita
  def initialize(cake_model, cake_size)
    @cake_model = cake_model
    # Matrix cake_size x cake_size
    @cake_size = cake_size
    # Masita should be the last item of cake_model
    @masita = cake_model.last
  end

  def get_number_of_delicious_cakes
    nr_deliciuos_cake = 0
    #all permutation of the cake_model of size N-1
    @cake_model.permutation(@cake_model.size - 1).each do |cake|
      # Build the matrix with the 3 columns for the current permutation array
      m_cake = Matrix.columns(cake.each_slice(@cake_size).to_a)
      nr_deliciuos_cake += 1 if delicious?(m_cake)
    end
    nr_deliciuos_cake
  end


  def delicious? (cake)
    h_delicious?(cake) || v_delicious?(cake)
  end

  def h_delicious? (matrix)
    for i in 0..(matrix.row_size - 1)
      row = matrix.row(i).to_a
      return true if is_delicious?(row)
    end
    false
  end

  def v_delicious?(matrix)
    for i in 0..(matrix.column_size - 1)
      column = matrix.column(i).to_a
      return true if is_delicious?(column)
    end
    false
  end

  def is_delicious?(line)
    # if size == 1 the line should have n eql cookies
    # if size == 2 the line can be delicious if one elem is masita and the other one is a cookie
    line = unica(line)
    (line.size == 1 || (line.size == 2 && line.include?(@masita)))
  end
  def unica(line)
    line.map { |e| e[0] }.uniq
  end

end


describe CakeFactory do
  let (:cake_factory) {CakeFactory.new(['a1','a2','a3','b1','b2','b3','d1','d2','d3','c'], 3)}
  it 'can be horizontally delicious' do
    m = Matrix[ ['a1','a2','a3'],
                ['b1','d3','b2'],
                ['d1','d2','b3']]
    cake_factory.h_delicious?(m).should be_true
  end
  it 'can be horizontally delicious(sad path)' do
    m = Matrix[ ['a1','a2','b1'],
                ['a3','d3','b2'],
                ['d1','d2','b3']]
    cake_factory.h_delicious?(m).should be_false
  end
  it 'can be vercaly delicious' do
    m = Matrix[ ['b1','a1','b3'],
                ['d2','a3','b2'],
                ['d3','a2','d1']]
    cake_factory.v_delicious?(m).should be_true
    m = Matrix[ ['b1','a1','b3'],
                ['d2','a3','b2'],
                ['c','a2','d1']]
    cake_factory.v_delicious?(m).should be_true
  end

  it 'can be vercaly delicious(sad path)' do
    m = Matrix[ ['a1','b1','b3'],
                ['b2','d3','a2'],
                ['a3','d2','d1']]
    cake_factory.v_delicious?(m).should be_false
    m = Matrix[ ['a1','b1','b3'],
                ['b2','d3','a2'],
                ['c','d2','d1']]
    cake_factory.v_delicious?(m).should be_false
  end

  it 'can be vercaly delicious(sad path)' do
    m = Matrix[ ['a1','b1','b3'],
                ['b2','d3','a2'],
                ['a3','d2','d1']]
    cake_factory.v_delicious?(m).should be_false
  end

  it 'line can be delicious' do
    ar = ['a3','a2','a1']
    cake_factory.is_delicious?(ar).should be_true
    ar = ['a3','a2','c']
    cake_factory.is_delicious?(ar).should be_true
  end

  it 'line can be delicious(sad path)' do
    ar = ['a3','d2','d1']
    cake_factory.is_delicious?(ar).should be_false
  end

  it do
    p "Numero maximo de Tortas Ricas: #{cake_factory.get_number_of_delicious_cakes}"
  end

end