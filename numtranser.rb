#encoding: utf-8
require 'numbers_and_words'
require 'yaml'

$kanji = YAML.load(File.open("./kanji_num.yml"))

$result_t = Struct.new(:type,:value,:denom,:numer,:ex)

$N = 0#整数 
$D = 1#小数
$F = 2#分数
$O = 3#序数
$C = 4#基数词 string 仅在comma模式
$E = 5#序数词 string comma模式/普通模式

$NO = 0
$N1 = 1
$N2 = 3
$N3 = 4

class Numtranser
	def  initialize
		I18n.enforce_available_locales = false
		@default_outputtype = "trad"
		@default_englishtype = "arabic"

		@MINUS = "負"
		@DECIMAL = "點"
		@digits =["零", "一", "二", "三", "四", "五", "六", "七", "八", "九"]
		@digits_map = {
		    "０" => 0, "0" => 0, "零" => 0, "〇" => 0,	
	        "１" => 1, "1" => 1, "一" => 1, "壹" => 1,
	        "２" => 2, "2" => 2, "二" => 2, "貳" => 2, "贰" => 2, "兩" => 2, "两" => 2, "俩" => 2,
	        "３" => 3, "3" => 3, "三" => 3, "參" => 3, "叄" => 3, "叁" => 3, "仨" => 3,
	        "４" => 4, "4" => 4, "四" => 4, "肆" => 4,
	        "５" => 5, "5" => 5, "五" => 5, "伍" => 5,
	        "６" => 6, "6" => 6, "六" => 6, "陸" => 6, "陆" => 6,
	        "７" => 7, "7" => 7, "七" => 7, "柒" => 7,
	        "８" => 8, "8" => 8, "八" => 8, "捌" => 8,
	        "９" => 9, "9" => 9, "九" => 9, "玖" => 9,}

		@beforeWan = ["十", "百", "千"]
		@beforeWan_map = {
			"十" => 10, "拾" => 10,
			"百" => 100, "佰"=> 100,
			"千" => 1000, "仟"=> 1000,}

		@afterWan = ["", "萬", "億", "兆", "京"] 
		@afterWan_map = {"萬" => 10000, "万" => 10000,
			"億" => 100000000, 	"亿" => 100000000,
			"兆" => 1000000000000,
			"京" => 10000000000000000} 

		@ALTTWO = "兩"
		@TEN = 10

		@trad2simp_map = {
			"負" => "负", 
			"點" => "点",
			"零" => "零", 
			"一" => "一",
			"二" => "二",
			"三" => "三", 
			"四" => "四",
			"五" => "五",
			"六" => "六",
			"七" => "七",
			"八" => "八",
			"九" => "九",
			"十" => "十",
			"百" => "百",
			"千" => "千", 
			"萬" => "万",
			"億" => "亿",
			"兆" => "兆", 
			"兩" => "两",
			"點" => "点" }

		@trad2formal_map = {
			"負" => "負", 
			"點" => "點",
			"零" => "零", 
			"一" => "壹",
			"二" => "貳",
			"三" => "參", 
			"四" => "肆",
			"五" => "伍",
			"六" => "陸",
			"七" => "柒",
			"八" => "捌",
			"九" => "玖",
			"十" => "拾",
			"百" => "佰",
			"千" => "仟", 
			"萬" => "萬",
			"億" => "億",
			"兆" => "兆", 
			"兩" => "兩",
			"點" => "點" }
	    @trad2formalsimp_map = {
	    	"負" => "负", 
			"點" => "点",
			"零" => "零", 
			"一" => "壹",
			"二" => "贰",
			"三" => "叁", 
			"四" => "肆",
			"五" => "伍",
			"六" => "陆",
			"七" => "柒",
			"八" => "捌",
			"九" => "玖",
			"十" => "拾",
			"百" => "佰",
			"千" => "仟", 
			"萬" => "万",
			"億" => "亿",
			"兆" => "兆", 
			"兩" => "两" }
	end

	def get_transe4web(text)
		text<<"\r\n"
		count=0
		wait_words = ""
		textlen = text.length - 1
		i = 0
		result_text = ""
		while (i<textlen)
			if  count >= 1
			  	if $kanji["用词"][text[i]] != nil
					wait_words << text[i]
					count += 1
					i+=1
				else
					if(wait_words != "第")
						lasti = wait_words.length-1
						while($kanji["不可结尾"][wait_words[lasti]] != nil)
							wait_words.chop!
							i -= 1
							lasti -= 1
						end
					else
						result_text<<"第"
						wait_words.clear
						count=0
						i+=1
						next
					end
					#候选串
					#puts wait_words

					temp = judge_yue_words(wait_words)
					if temp == $N0
						if wait_words == "几" or wait_words == "好几"
							result_words = "several"
							result_text << highlight(wait_words,result_words)
						elsif wait_words[-1] == "分"
							if wait_words.include?("点")
								tmp = wait_words.split("点")
								tnum1 = ChineseToEnglishNumber(tmp[0])
								tnum2 = ChineseToEnglishNumber(tmp[1].chop!)
								result_text << highlight(wait_words,tnum1.value.to_s+":"+tnum2.value.to_s)
							else
								puts "fdfdfdfdf"
								wait_words.chop!
								if !wait_words.empty?
									m = ChineseToEnglishNumber wait_words.clone
									if m.type == $N
										result_text << highlight(wait_words,(m.ex)+num2en(m.value))
									elsif m.type == $F && (m.denom == 100 or m.denom==1000)
										s = m.numer.to_s
										if m.numer.class == (1/1).to_r.class
											s=m.numer.to_f.to_s
										end
										result_text << highlight(wait_words,(m.ex)+s+"/"+m.denom.to_s)
									else
										result_text << highlight(wait_words,(m.ex)+m.value.to_s)
									end
								end
								result_text << "分"
							end
						elsif wait_words[-1] != "分" && wait_words.include?("点") && (timemat(wait_words)==1 or timemat(wait_words)==2)
							if(timemat(wait_words)==1)
								tmp = wait_words.split("点")
								tnum1 = ChineseToEnglishNumber(tmp[0])
								tnum2 = ChineseToEnglishNumber(tmp[1])
								result_text << highlight(wait_words,tnum1.value.to_s+":"+tnum2.value.to_s)
							else
								tmp = wait_words.split("点")
								tnum1 = ChineseToEnglishNumber(tmp[0])
								tnum2 = ChineseToEnglishNumber(tmp[1])

								m = ChineseToEnglishNumber tnum1.clone
								if m.type == $N
									result_text << highlight(wait_words,(m.ex)+num2en(m.value))
								elsif m.type == $F && (m.denom == 100 or m.denom==1000)
									s = m.numer.to_s
									if m.numer.class == (1/1).to_r.class
										s=m.numer.to_f.to_s
									end
									result_text << highlight(wait_words,(m.ex)+s+"/"+m.denom.to_s)
								else
									result_text << highlight(wait_words,(m.ex)+m.value.to_s)
								end
								result_text << "点"
								m = ChineseToEnglishNumber tnum2.clone
								if m.type == $N
									result_text << highlight(wait_words,(m.ex)+num2en(m.value))
								elsif m.type == $F && (m.denom == 100 or m.denom==1000)
									s = m.numer.to_s
									if m.numer.class == (1/1).to_r.class
										s=m.numer.to_f.to_s
									end
									result_text << highlight(wait_words,(m.ex)+s+"/"+m.denom.to_s)
								else
									result_text << highlight(wait_words,(m.ex)+m.value.to_s)
								end
							end
							
						else
							m = ChineseToEnglishNumber wait_words.clone
							if m.type == $N
								result_text << highlight(wait_words,(m.ex)+num2en(m.value))
							elsif m.type == $F && (m.denom == 100 or m.denom==1000)
								s = m.numer.to_s
								if m.numer.class == (1/1).to_r.class
									s=m.numer.to_f.to_s
								end
								result_text << highlight(wait_words,(m.ex)+s+"/"+m.denom.to_s)
							else
								result_text << highlight(wait_words,(m.ex)+m.value.to_s)
							end
						end
					elsif temp == $N2
						sub_words = wait_words.split('、')
						sub_words.each do 
							|sub_word|
							m = ChineseToEnglishNumber sub_word
							if m.type == $N
								result_text << highlight(sub_word,(m.ex)+num2en(m.value))+"、"
							elsif m.type == $F && (m.denom == 100 or m.denom==1000)
								s = m.numer.to_s
								if m.numer.class == (1/1).to_r.class
									s=m.numer.to_f.to_s
								end
								result_text << highlight(sub_word,(m.ex)+s+"/"+m.denom.to_s)+"、"
							else
								result_text << highlight(sub_word,(m.ex)+m.value.to_s)+"、"
							end
						end
						result_text.chop!
					elsif temp == $N3
						yueshu = ["一二","二三","三四","四五","五六","六七","七八","八九","九十"]
						match_i = -1
						0.upto(8) do |i|
							if wait_words.include?(yueshu[i])
								match_i = i
								break
							end
						end
						site = wait_words.index(yueshu[match_i])
						word1 = wait_words[0..site] + wait_words[site+2..-1]
						word2 = wait_words[0...site] + wait_words[site+1..-1]
						num1 = ChineseToEnglishNumber word1
						num2 = ChineseToEnglishNumber word2
						q1 = (num1.ex)+num1.value.to_s
						q2 =(num2.ex)+num2.value.to_s

						q1 = (num1.ex)+num2en(num1.value) if num1.type == $N
						q2 = (num2.ex)+num2en(num2.value) if num2.type == $N
						
						s1 = num1.numer.to_s
						if num1.numer.class == (1/1).to_r.class
							s1=num1.numer.to_f.to_s
						end
						s2 = num2.numer.to_s
						if num2.numer.class == (1/1).to_r.class
							s2=num2.numer.to_f.to_s
						end

						q1 = (num1.ex)+s1+"/"+num1.denom.to_s if num1.type == $F && (num1.denom == 100 or num1.denom==1000)
						
						q2 = (num2.ex)+s2+"/"+num2.denom.to_s if num2.type == $F && (num2.denom == 100 or num2.denom==1000)
						result_text << highlight(wait_words,q1+ "、"+q2)
					else #$N1
						site = wait_words.index('、')
						increase_flag = false
						fit_grammer = false
						if($kanji["约数"][wait_words[site-1]+wait_words[site+1]] != nil)
							increase_flag = true
							if site+1 == wait_words.length-1#三十二、三
								fit_grammer = true
							elsif site-1 == 0 #二、三十万
								fit_grammer = true
							elsif $kanji["级词"][wait_words[site+2]] != nil #三十二、三万 
								fit_grammer = true
							elsif $kanji["数位"][wait_words[site-2]] > $kanji["数位"][wait_words[site+2]] #三十万二、三千
								fit_grammer = true
							end

							if fit_grammer == true #分成两个相关的串
								word1 = wait_words[0..site-1]+wait_words[site+2..-1]
								word2 = wait_words[0...site-1]+wait_words[site+1..-1]
								num1 = ChineseToEnglishNumber word1
								num2 = ChineseToEnglishNumber word2
								q1 = (num1.ex)+num1.value.to_s
								q2 =(num2.ex)+num2.value.to_s
								q1 = (num1.ex)+num2en(num1.value) if num1.type == $N
								q2 = (num2.ex)+num2en(num2.value) if num2.type == $N
								s1 = num1.numer.to_s
								if num1.numer.class == (1/1).to_r.class
									s1=num1.numer.to_f.to_s
								end
								s2 = num2.numer.to_s
								if num2.numer.class == (1/1).to_r.class
									s2=num2.numer.to_f.to_s
								end

								q1 = (num1.ex)+s1+"/"+num1.denom.to_s if num1.type == $F && (num1.denom == 100 or num1.denom==1000)
								
								q2 = (num2.ex)+s2+"/"+num2.denom.to_s if num2.type == $F && (num2.denom == 100 or num2.denom==1000)
								result_text << highlight(wait_words,q1+ "、"+q2)
							else#分成两个无关串
								exo = ""
								if wait_words[0]=="第"
									exo="第"
								end
								ii = 0
								sub_words = wait_words.split('、')
								sub_words.each do 
									|sub_word|
									if (ii>0)
										tt = exo
									else
										tt = ""
									end 
									m = ChineseToEnglishNumber tt+sub_word
									if m.type == $N
										result_text << highlight(sub_word,(m.ex)+num2en(m.value))+"、"
									elsif m.type == $F && (m.denom == 100 or m.denom==1000)
										s = m.numer.to_s
										if m.numer.class == (1/1).to_r.class
												s=m.numer.to_f.to_s
										end
										result_text << highlight(sub_word,(m.ex)+s+"/"+m.denom.to_s)+"、"
									else
										result_text << highlight(sub_word,(m.ex)+m.value.to_s)+"、"
									end
									ii+=1
								end
								result_text.chop!	
							end
						else#分成两个无关串
							    exo = ""
								if wait_words[0]=="第"
									exo="第"
								end
								ii = 0
								sub_words = wait_words.split('、')
								sub_words.each do 
									|sub_word|
									if (ii>0)
										tt = exo
									else
										tt = ""
									end 
									m = ChineseToEnglishNumber tt+sub_word
									if m.type == $N
										result_text << highlight(sub_word,(m.ex)+num2en(m.value))+"、"
									elsif m.type == $F && (m.denom == 100 or m.denom==1000)
										s = m.numer.to_s
										if m.numer.class == (1/1).to_r.class
												s=m.numer.to_f.to_s
										end
										result_text << highlight(sub_word,(m.ex)+s+"/"+m.denom.to_s)+"、"
									else
										result_text << highlight(sub_word,(m.ex)+m.value.to_s)+"、"
									end
									ii+=1
								end
							result_text.chop!	
						end
					end
					wait_words.clear
					count = 0
				end
			else
				if $kanji["用词"][text[i]] != nil
					if  $kanji["不可开头"][text[i]] != nil
						wait_words.clear
						result_text << text[i] #废词输出
						count = 0
					else
						wait_words << text[i]
						count += 1
					end
				else
					result_text << text[i] #废词输出
					wait_words.clear
					count = 0
				end
				i+=1
			end	
		end
		return result_text
	end#end-func

	def timemat(words)
		tmp = words.split("点")
		if tmp[1].length<=3 && tmp[1].include?("十") && !tmp[1].include?("百") && !tmp[1].include?("千") && !tmp[1].include?("万") && !tmp[1].include?("亿")
			return 1
		elsif tmp[1].include?("百") or tmp[1].include?("千") or tmp[1].include?("万") or tmp[1].include?("亿")
			return 2
		else
			return 0
    	end
    end

	def judge_yue_words(wait_word)
		yueshu = ["一二","二三","三四","四五","五六","六七","七八","八九","九十"]

		count = wait_word.count('、')
		if count == 1
			return $N1
		elsif count == 0
			match_i = -1
			0.upto(8) do |i|
				if wait_word.include?(yueshu[i])
					match_i = i
					break
				end
			end
			if match_i >= 0
				if wait_word.length == 2 # 一二
					return $N3
				end

				if wait_word.index(yueshu[match_i])-1 >= 0#一二前有字符
					char = wait_word[wait_word.index(yueshu[match_i])-1]
					if $kanji["数位"][char] != nil#前是数位 十一二
						return $N3
					else#前不是数位
						return $N0
					end 
				else#一二前无字符，后有字符
					char = wait_word[wait_word.index(yueshu[match_i])+2]
					if $kanji["数位"][char] != nil#后是数位 一二十
						return $N3
					else#后不是数位
						return $N0
					end
				end 
			end
			#puts wait_word
			return $N0
		else 
			return $N2
		end
	end#end-func

	# def EnglishToChineseNumber(enumber,outputtype)
	# 	@outputtype = @default_outputtype if outputtype == ""
	# 	@outputtype.downcase!
	# 	powers=[]
	# 	power = 0
	# 	value = 0
	# 	negative = 0
	# 	inzero = 0
	# 	canaddzero = 0
	# 	cnumber = ""
	# 	remainder = ""

	# 	temp = /[\A\.\d-]/x.match(enumber)
	# 	enumber = temp[0]
	# 	if enumber.include?('.')
	# 		enumber = enumber.to_f
	# 	else
	# 		enumber = enumber.to_i
	# 	end

	# 	if enumber == 0
	# 		return @digits[0]
	# 	end

	# 	if enumber < 0
	# 		negative = 1
	# 		enumber = -enumber
	# 	end
	# 	enumber = enumber.to_s
	# 	if t = /([0-9]*)\.([0-9]+)/.match(enumber) != nil
	# 		remainder = t[1]
	# 		enumber = t[0]
	# 	end
	# 	enumber = enumber.to_i
	# 	while (@TEN ** power <= enumber) do
	# 		value = (enumber % (@TEN** (power+1)))/(@TEN**power);
	# 		powers[power] = value;

	# 		# Subtract out the current power's coefficient and increase the power
	# 		enumber -= enumber % (@TEN**(power+1));
	# 		power+=1;
 #    	end

 #    	0.upto(power-1) do
 #    		|i|
 #    		if i%4 == 0
 #    			if powers[i] != 0
 #    				inzero = 0
 #    				canaddzero = 1
 #    				cnumber = @digits[powers[i]]+@afterWan[i/4]+cnumber
 #    			else
 #    				if (((i+3 < power) && powers[i+3] != 0) ||
	# 				    ((i+2 < power) && powers[i+2] != 0) ||
	# 				    ((i+1 < power) && powers[i+1] != 0)) 
					
	# 				    cnumber = @afterWan[i/4] + cnumber
	# 				    canaddzero = 0 # added
	# 				end
 #    			end
 #    		else
 #    			if powers[i] != 0 
	# 				inzero = 0
	# 				canaddzero = 1
	# 				if (power == 2 && i == 1 && powers[i] == 1)  # No 一 with 10 through 19
	# 				    cnumber = @beforeWan[(i % 4)-1] + cnumber
	# 				    #} else if ((i%4 = 3) && powers[i] == 2) {  # when to use liang3 vs. er4
	# 				    #cnumber.insert(0, ALTTWO + beforeWan[(i%4)-1]);
	# 				else
	# 				    cnumber = @digits[powers[i]] + beforeWan[(i%4)-1] + cnumber
	# 				end
	# 			else 
	# 				if (canaddzero == 1 && inzero == 0)  # Only insert one 零 for all consecutive zeroes
	# 				    inzero = 1
	# 				    cnumber = digits[powers[i]] + cnumber
	# 				end
	# 			end
 #    		end
 #    	end#end-loop


	#     if (!remainder.empty?)
	# 		cnumber += @DECIMAL;
	# 		remainder.each_char do
	# 			|char|
	# 			cnumber += @digits[char]
	# 		end
	#     end

	#     # Add the negative character
	#     if (negative == 1)
	# 		cnumber += @MINUS;
	#     end
	 
	#     result = $result_t.new($N,"",0,0)
	#     j

	#     if (outputtype == "trad")
	# 		result.value = cnumber
	#     elsif (outputtype == "simp")
	#      	cnumber.each_char do 
	#      		|char|
	#      		result.value << @trad2simp_map[char]
	#      	end
	#     elsif (outputtype == "formaltrad")
	#     	cnumber.each_char do 
	#     		|char|
	#      		result.value << @trad2formal_map[char]
	#      	end
	#     elsif (outputtype == "formalsimp")
	#     	cnumber.each_char do
	#     	 |char|
	#      		result.value << @trad2formalsimp_map[char]
	#      	end
	#     else 
	# 		result.value = cnumber;
	#     end

	#     return result 

	# end#end-func

	def ChineseToEnglishNumber(cnumber,outputtype="")
		if cnumber.length==0
			puts "Seems to be an error in the number. cnumber\n"
	   		return ""	
		end
		#puts "正在翻译："+cnumber
		outputtype = @default_englishtype if(outputtype == "") 
		outputtype.downcase!

		result = $result_t.new($N,0,0,0,"")
		alldigits = 1
		ordinal  = 0
		yue = 0
		
		if ( cnumber.gsub!(/几/, "0") !=nil || 
		   cnumber.gsub!(/好几/, "0")!=nil || 
		   cnumber.gsub!(/多/, "0") !=nil || 
		   cnumber.gsub!(/余/, "0")!=nil || 
		   cnumber.gsub!(/来/, "0") !=nil)
			yue = 1
		end
		

		if /^第/.match(cnumber)!=nil 
		    ordinal = 1
		    cnumber.gsub!(/第第/, "第")
		end

		if /分之/.match(cnumber)!=nil
			denom = /^(.+?)分之/.match(cnumber)
			numer = /分之(.+)/.match(cnumber)
			result.type = $F
			result.numer = ChineseToEnglishFull(numer[1])
			result.denom = ChineseToEnglishFull(denom[1])
			result.value = Rational(result.numer,result.denom)
		elsif /\//.match(cnumber)!=nil
			numer = /^(.+?)\//.match(cnumber)
			denom = /\/(.+)/.match(cnumber)
			result.type = $F
			result.numer = ChineseToEnglishFull(numer[1])
			result.denom = ChineseToEnglishFull(denom[1])
			result.value = Rational(result.numer,result.denom)
		elsif /%/.match(cnumber)!=nil
			numer = /^(.+?)%/.match(cnumber)
			denom = "100"
			result.type = $F
			result.numer = ChineseToEnglishFull(numer[1])
			result.denom = ChineseToEnglishFull(denom)
			result.value = Rational(result.numer,result.denom)
		elsif /‰/.match(cnumber)!=nil
			numer = /^(.+?)‰/.match(cnumber)
			denom = "1000"
			result.type = $F
			result.numer = ChineseToEnglishFull(numer[1])
			result.denom = ChineseToEnglishFull(denom)
			result.value = Rational(result.numer,result.denom)
		elsif cnumber.length > 1
			cnumber.each_char do
				|char|
				alldigits = 0 if(@digits_map[char] == nil) 
			end

			if alldigits == 1
				result.type = $N
				result.value = ChineseToEnglishBrief(cnumber)
				if result.value.class == (1/1).to_r.class
					result.value=result.value.to_f
					result.type = $D
				end
			else
				result.type = $N
				if(yue==1)
					result.ex="about "
				end
				result.value = ChineseToEnglishFull(cnumber)
				if result.value.class == (1/1).to_r.class
					result.value=result.value.to_f
					result.type = $D
				end
			end
		else 
			result.type = $N
			if(yue==1)
					result.ex="about "
			end
			result.value = ChineseToEnglishFull(cnumber)
			if result.value.class == (1/1).to_r.class
				result.value=result.value.to_f
				result.type = $D
			end
		end
		

		if outputtype == "arabic" 
			if ordinal==1
				result.type = $O
				result.value = result.value.to_s
			    lastdigit = result.value[-1]
			    if lastdigit == "1"
					result.value += "st"
			    elsif lastdigit == "2"
				    result.value += "nd"
			    elsif lastdigit == "3"
				    result.value += "rd"
			    else
				    result.value += "th"
			    end
			end
			return result
		elsif outputtype == "comma" 
			withcomma = result.clone
			withcomma.type = $C
			withcomma.value = withcomma.value.to_s 
			start = 0
			if /\./.match(withcomma.value) != nil
			else
				count = withcomma.value.length / 3
				start = withcomma.value.length % 3
				count.downto(1) do
					withcomma.value.insert(start,",")
					start += 4 
				end
				if withcomma[0]==","
					withcomma.slice!(0)
				end
			end

			if ordinal==1
				withcomma.type = $O
				lastdigit = withcomma.value[-1]
			    if lastdigit == "1"
					withcomma.value += "st"
			    elsif lastdigit == "2"
				    withcomma.value += "nd"
			    elsif lastdigit == "3"
				    withcomma.value += "rd"
			    else
				    withcomma.value += "th"
			    end
			end
			return withcomma
		elsif outputtype == "words"
			if ordinal==1
				result.type = $E 
	    		result.value = num2en_ordinal(result.value)
			else
				result.type = $C
	    		result.value = num2en(result.value)
			end
		end#end-if-elsif-elsif-end
   	end#end-func
	
	def ChineseToEnglishBrief (cnumber)
		digitval=0
		total=0
		cnumber.each_char do
			|digit|
			total *= 10
			digitval = @digits_map[digit]
			total += digitval
		end
		return total
	end#end-func
   	
   	def ChineseToEnglishFull (cnumber)
   		negative = 0
   		digitval = 0
   		afterdecimal = 0
   		power = 0
   		leveltotal = 0
   		total = 0
   		nextcchar =""
   		prevchar = ""

   		cnumber.gsub!(/万亿/, "兆")
   		cnumber.gsub!(/萬億/, "兆")
   		cnumber.gsub!(/亿万/, "兆")
   		cnumber.gsub!(/億萬/, "兆")
   		cnumber.gsub!(/万万/, "亿")
   		cnumber.gsub!(/個/, "")
   		cnumber.gsub!(/个/, "")
   		cnumber.gsub!(/廿/, "二十")
   		cnumber.gsub!(/卄/, "二十")
   		cnumber.gsub!(/卅/, "三十")
   		cnumber.gsub!(/卌/, "四十")

   		cnumlength = cnumber.length
   		i = 0
   		char =""
   		while(i<cnumlength) do

   			char = cnumber[i]
   			if(i==0 && (char=="负" or char == "負" or char=="-"))
   				negative = 1
   			elsif i==0 && char=="第"
   			elsif(char=="點" or char=="点" or char=="." or char=="．")
				afterdecimal = 1
				power = -1
			elsif char=="兆"
				power = 12
				leveltotal = 1 if leveltotal == 0
				total += leveltotal*(10**power)
				leveltotal = 0
				power -= 4
			elsif char=="億" or char=="亿"
				power = 8
				leveltotal = 1 if leveltotal == 0
				total += leveltotal*(10**power)
				leveltotal = 0
				power -= 4
			elsif char=="萬" or char=="万"
				power = 4
				leveltotal = 1 if leveltotal == 0
				total += leveltotal*(10**power)
				leveltotal = 0
				power -= 4
			elsif char=="千" or char == "仟"
				leveltotal += 1000
			elsif char=="百" or char == "佰"
				leveltotal += 100
			elsif char=="十" or char == "拾"
				leveltotal += 10
			elsif (char=="零" or char=="〇" or
				char=="0" or char=="０")
				if afterdecimal == 0
					power = 0
				else
					power -= 1
				end
			elsif @digits_map[char]!= nil 
				digitval = @digits_map[char]
				if afterdecimal==1
					leveltotal += digitval * (10**power)
					power -= 1
					while(i+1<cnumlength and @digits_map[cnumber[i+1]])
						leveltotal += @digits_map[cnumber[i+1]]*(10**power)
						power-=1
						i+=1
					end
				elsif i+1 < cnumlength
					nextcchar = cnumber[i+1]
					if(nextcchar == "十" or nextcchar == "拾")
						leveltotal += digitval *10
						i+=1
					elsif (nextcchar == "百" or nextcchar == "佰")
						leveltotal += digitval *100
						i+=1
					elsif (nextcchar == "千" or nextcchar == "仟")	
						leveltotal += digitval *1000
						i+=1
					elsif @digits_map[nextcchar]!=nil
						leveltotal *= 10
						leveltotal += digitval
						while(i+1<cnumlength and @digits_map[cnumber[i+1]]) do
							leveltotal *=10
							leveltotal += @digits_map[cnumber[i+1]]
							i+=1
						end
					else
						leveltotal += digitval
					end
				else
					if i+1 == cnumlength && i>0
						prevchar = cnumber[i-1]
						if prevchar =='兆'
							leveltotal += digitval * (10**11)
						elsif prevchar =='億' or prevchar == '亿'
							leveltotal += digitval * (10**7)
						elsif prevchar == '萬' or prevchar =='万'
							leveltotal += digitval * 1000
						elsif prevchar == '千' or prevchar == '仟'
							leveltotal += digitval * 100
				        elsif prevchar == "百" or prevchar == '佰'
							leveltotal += digitval * 10
						else
							leveltotal += digitval
						end
					else
						leveltotal += digitval
					end
				end
			else
				puts "Seems to be an error in the number. cnumber\n"
		   		return ""	
   			end
   			i+=1
   		end#end-while
   		 

	    # Catch remaining leveltotal
	    #print("Level total " + leveltotal + " power " + power + " ten to power " + (10**power)/10)

	    total += leveltotal # * 10** power

	    #if (cchar == '點' or cchar == '点' or cchar == '.') {
	    #power = -1
	    #for (j = i+1 j < cnumlength j++, power--) {
	    #digitval = digits{substru8(cnumber, j, 1)}
	    #total += digitval * (10 ** power)
	    # }
	    #}
	  

	   	total = -total if negative == 1 

	    return total
	end#end-func
    
    def chinese_output (myself,outputtype)
    	@default_outputtype = outputtype if(!outputtype.empty?)
    	return @default_outputtype
    end#end-func

    def english_output (myself, englishtype)
    	@default_englishtype = englishtype if (!englishtype.empty?)
    end#end-func

    def num2en_ordinal(num)
    	I18n.with_locale(:en) { num.to_words ordinal: true }
    end#end-func

    def num2en(num)
    	I18n.with_locale(:en) { num.to_words }
    end#end-func

   	def highlight(str, value)
      "<a href='#' class='highlight' data-toggle='tooltip' title='#{value}'>#{str}</a>"
    end#end-func

end#end-class
