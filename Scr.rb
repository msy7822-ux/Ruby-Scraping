# ライブラリの読み込み
require 'open-uri'

# 熊本の避難所データの取得
open('https://www.geospatial.jp/ckan/dataset/db74071f-cd0a-406d-ba3d-57c7a25d9925/resource/7bb9e998-d108-44ea-9515-6adc0906b667/download/43.geojson') do |io|
  File.open '43_geojson.txt', 'w' do |f|
    f.puts io.read
  end
end


# 避難所のデータの配列（座標用）
safe_place_array = []

File.foreach("43_geojson.txt"){|line|
  array = line.split(":")
  array.each_with_index do |s, index|
    if s.include?('coordinates')
      safe_place_array << array[index + 1]
    end
  end
}

# 取得したデータについている末尾の改行文字を取得
safe_place_array = safe_place_array.each do |s|
  s.chomp
end



# X座標データの配列
x_array = []
# Y座標データの配列
y_array = []

# データの細かい整形（不要部分の削ぎ落とし）
safe_place_array.map {|str|
  array = str.split(',')
  array.delete_at(2)
  x_array << array[0].delete(' [ ')
  y_array << array[1].delete(' ] } },')
}

# X座標用のテキストファイルへ書き出し
File.open 'x_data.txt', "a" do |line|
  x_array.each do |x|
    line.puts x.to_f
  end
end

# Y座標用のテキストファイルへ書き出し
File.open 'y_data.txt', "a" do |line|
  y_array.each do |y|
    line.puts y.to_f
  end
end

# 避難所のデータの配列（施設名用）
safe_place_array = []

File.foreach("43_geojson.txt"){|line|
  array = line.split(":")
  array.each_with_index do |s, index|
    if s.include?('指定緊急避')
      safe_place_array << array[index + 1]
    end
  end
}

# 避難所の施設の名前データの配列
names_array = []

# データの整形と新たな配列への挿入
safe_place_array.map {|str|
  array = str.split(',')
  array.delete_at(1)
  names_array << array[0]
}


# テキストファイルへの書き出し
File.open 'safe_names.txt', "a" do |line|
  names_array.each do |name|
    line.puts name
  end
end



