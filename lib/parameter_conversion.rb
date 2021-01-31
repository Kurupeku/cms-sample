# frozen_string_literal: true

# pamams convert snakecase from camelcase
module ParameterConversion
  def snakalize_keys(hash = {})
    hash.map do |k, v|
      value = if v.is_a?(Hash)
                snakalize_keys v
              else
                v
              end
      [k.to_s.underscore.to_sym, value]
    end.to_h
  end

  def convert_ransack_params(params)
    sorted = sorting(params)
    create_conbinates(**sorted)
  end

  module_function :convert_ransack_params, :snakalize_keys

  private

  def sorting(params = {})
    single = []
    multi = []
    sort_each(params, single, multi)
    { single: single, multi: multi }
  end

  def sort_each(params, single, multi)
    params.each do |k, v|
      if k.to_s =~ /\Aid_.+\z/
        val = v.instance_of?(Array) ? v : v.to_i
        single << [k, val]
      elsif k.to_s =~ /\A.+_cont_all\z/
        multi = split_and_merge_values multi, k, v
      else
        single << [k, v]
      end
    end
  end

  def split_and_merge_values(acc, key, val)
    pairs = val.split(/[\s　,]+/).map do |word|
      [key, word]
    end
    acc.concat pairs
  end

  def create_conbinates(single: [], multi: [])
    return single.to_h if multi.size.zero?

    products = multi.permutation(multi.size).map do |pair|
      { **single.to_h, **pair.to_h }
    end

    { groupings: products }
  end
end
