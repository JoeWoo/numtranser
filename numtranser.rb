#encoding: utf-8
require 'yaml'
#require File.dirname(__FILE__)+"/NLPIR.rb"
#include NLPIR
$kanji = YAML.load(File.open("./kanji_int.yml"))
class Numtranser
    def initialize()
      

      @stat = 0           #自动机状态
      @num = 0            #当前进入自动机数字

      @value = 0          #数值
      @int_part = 0       #整数部分
      @decimal_part = "" #小数部分
      @denominator = 1   #分母

      @order=1            #预推阶值
      @order_value = 0   #阶值    XX亿、XX万、XX个
      @pos_value = 0     #位值    X千X百X十X

      @numstring = ""    #处理纯阿拉伯数字串
      @kanjinumstring = ""   #处理年份\电话号码\等连续汉字数字 一九七八
      @kanjitext = ""
      @rangeHead = ""
      @rangeBody = []
      @rangeTail = ""
      @rangeFlag == 0
      @dept = 0

      @result=""
      @simpleResult=""
      clear
    end

    def printNum()
      value =""
      str = @kanjitext.clone 
      if (@ordinal_numeral == 0   || @stubFlag == 1) && @noPrintOrderFlag == 0
        if @moreOrLess.size != 0
          value << @moreOrLess+" "+ @value.to_s
        else
          if @percentFlag == 1
            value << @value.to_s + "%"
            @percentFlag = 0
          else
            value << @value.to_s
          end
        end
      else
        value << "第"+@value.to_s
      end
      clear
     # if @dept == 0
       @result << highlight(str,value)
     # end
    end
    def simple_printNum()
      value =""
      #str = @kanjitext.clone 
      if (@ordinal_numeral == 0   || @stubFlag == 1) && @noPrintOrderFlag == 0
        if @moreOrLess.size != 0
          value << @moreOrLess+" "+ @value.to_s
        else
          if @percentFlag == 1
            value << @value.to_s + "%"
            @percentFlag = 0
          else
            value << @value.to_s
          end
        end
      else
        value << "第"+@value.to_s
      end
      clear
     # if @dept == 0
      return value
     # end
    end
    def calcuFloat()
      temp = @int_part.to_s + @decimal_part
      @value = temp.to_f
      @decimal_part.clear
    end

    def printFloat()
      #temp = @int_part.to_s + @decimal_part
      #@value = temp.to_f
      value =""
      str = @kanjitext.clone  #if @dept == 0
      ex=""
      ex="第" if @ordinal_numeral == 1 && @noPrintOrderFlag == 0
      if @moreOrLess.size != 0
        value << ex + @moreOrLess + @value.to_s
      else
        value << ex + @value.to_s
      end
      clear
      @result << highlight(str,value)
    end

    def simple_printFloat()
      #temp = @int_part.to_s + @decimal_part
      #@value = temp.to_f
      value =""
     # str = @kanjitext.clone  #if @dept == 0
      ex=""
      ex="第" if @ordinal_numeral == 1 && @noPrintOrderFlag == 0
      if @moreOrLess.size != 0
        value << ex + @moreOrLess + @value.to_s
      else
        value << ex + @value.to_s
      end
      clear
      return value
    end

    def printFraction()
      value =""
      str = @kanjitext.clone# if @dept == 0
      @pos_value += @num
      @num = 0
      @order_value = @pos_value
      @pos_value = 0
      @value += @order_value
      @order_value = 0
      @int_part = @value
      temp = @int_part.to_s + @decimal_part
      @value = temp.to_f
      temp2 = @value
      @value=temp2/@denominator
        ex=""
        ex="第" if @ordinal_numeral == 1 && @noPrintOrderFlag == 0

        if @decimal_part == "."
          if @denominator == 100
            value << ex + @int_part.to_s + "%" + " = " + @value.to_s
          else
            value << ex + @int_part.to_s + "/" + @denominator.to_s + " = " + @value.to_s
          end
        else
          if @denominator == 100
            value << ex + temp2.to_s + "%" + " = " + @value.to_s
          else
            value << ex + temp2.to_s + "/" + @denominator.to_s + " = " + @value.to_s
          end
        end
        clear
       @result << highlight(str,value)
    end

    def simple_printFraction()
      value =""
      #str = @kanjitext.clone# if @dept == 0
      @pos_value += @num
      @num = 0
      @order_value = @pos_value
      @pos_value = 0
      @value += @order_value
      @order_value = 0
      @int_part = @value
      temp = @int_part.to_s + @decimal_part
      @value = temp.to_f
      temp2 = @value
      @value=temp2/@denominator
        ex=""
        ex="第" if @ordinal_numeral == 1 && @noPrintOrderFlag == 0

        if @decimal_part == "."
          if @denominator == 100
            value << ex + @int_part.to_s + "%" + " = " + @value.to_s
          else
            value << ex + @int_part.to_s + "/" + @denominator.to_s + " = " + @value.to_s
          end
        else
          if @denominator == 100
            value << ex + temp2.to_s + "%" + " = " + @value.to_s
          else
            value << ex + temp2.to_s + "/" + @denominator.to_s + " = " + @value.to_s
          end
        end
        clear
        return value
    end

    def printFraction2()
      value = ""
      str= @kanjitext.clone# if @dept == 0
      valuestring = @value.to_s
      @value = @value.to_f
      temp2 = @value
      @value=@denominator / temp2
      ex=""
      ex="第" if @ordinal_numeral == 1  && @noPrintOrderFlag == 0
      if valuestring.include?(".")
        if temp2 == 100
          value <<  ex + @denominator.to_s + "%" + " = " + @value.to_s
        else
          value <<  ex + @denominator.to_s + "/"+temp2.to_s + " = " + @value.to_s
        end
      else
        if temp2 == 100
          value  ex + @denominator.to_s + "%" + " = " + @value.to_s
        else
          value  ex + @denominator.to_s + "/"+valuestring + " = " + @value.to_s
        end
      end
      clear
      @result << highlight(str,value)
    end

    def simple_printFraction2()
      value = ""
      #str= @kanjitext.clone# if @dept == 0
      valuestring = @value.to_s
      @value = @value.to_f
      temp2 = @value
      @value=@denominator / temp2
      ex=""
      ex="第" if @ordinal_numeral == 1  && @noPrintOrderFlag == 0
      if valuestring.include?(".")
        if temp2 == 100
          value <<  ex + @denominator.to_s + "%" + " = " + @value.to_s
        else
          value <<  ex + @denominator.to_s + "/"+temp2.to_s + " = " + @value.to_s
        end
      else
        if temp2 == 100
          value  ex + @denominator.to_s + "%" + " = " + @value.to_s
        else
          value  ex + @denominator.to_s + "/"+valuestring + " = " + @value.to_s
        end
      end
      clear
      return value
    end

    def clear
      @rangeFlag=0
      @rangeTail=""
      @rangeBody=[]
      @rangeHead=""
      @chockFlag=0   

      @zeroFlag = 0
      @percentFlag = 0
      @fractionFlag = 0
      @stubFlag = 0
      @dunhao_times = 0
      @numstringFlag = 0
      @numstringRangeFlag = 0
      @numstringEndFlag = 0

      @ordinal_numeral = 0
      @noPrintOrderFlag = 0

      @moreOrLess = ""
      @kanjinumstring.clear
      @kanjitext.clear
      @int_part = 0
      @decimal_part = "."
      @stat = 0
      @value = 0
      @order =1#用于简写形式自动推算下一位的位上的权值三万二，六百三，四十二，十二
      @order_value = 0
      @pos_value = 0
      @num = 0
      @numstring.clear
    end

    def  printValue()
      puts "==============="
      puts @value
      puts @order_value
      puts @pos_value
      puts @num
      puts  @int_part     #整数部分
      puts  @decimal_part        #小数部分
      puts @denominator
      puts "hanzi:"+@kanjinumstring
      puts "==============="
    end

    def scanner_file
      f = File.open('./test.txt')
      f.set_encoding('utf-8')
      a = 0
      str=f.read
      autoMachine(str,a)
      # f.each_char do |str|
      #     autoMachine(str, a)
      #     # str.split("。").each do |token|
      #     #   puts token
      #     # #puts "now:"+token
      #     # autoMachine(token, a)
      #   #end
      # end
    end
    
    def scanner(str)
      f.set_encoding('utf-8')
      f.each_line do |str|
        str.split("，").each do |token|
          puts "now:"+token
          autoMachine(token, 0)
        end
      end
    end
    
    def calcu_range(dept)
      @kanjinumstring.clear
              chongdie=0
              if @rangeFlag != 0
                if @rangeBody[0].size == 1 && @rangeBody[1].size == 1
                  x =  $kanji['系数'][@rangeBody[1]]
                  y =  $kanji['系数'][@rangeBody[0]]
                  if x!=nil && y!=nil
                    if x-y==1
                      chongdie=1
                    else
                      chongdie=0
                    end
                  else
                    x= $kanji['数字'][@rangeBody[1]]
                    y= $kanji['数字'][@rangeBody[0]]
                    if x!=nil && y!=nil
                      if x-y==1
                        chongdie=1
                      else
                        chongdie=0
                      end
                    else
                      chongdie=0
                    end
                  end
                else
                  chongdie=0
                end
                m = ""
                 # puts "================="
                 #  puts  "bogy:"+@rangeBody.to_s
                 #   puts  "tail:" + @rangeTail.to_s
                 #  puts  "================="
                if @rangeTail.include?("、")                     
                  st = @rangeHead + @rangeBody[0] + " "
                  a=Numtranser.new()
                  m << a.simpleMachine(st,dept+1)+"、"
                  width = @rangeBody.size - 2
                  1.upto(width) do |i|
                    st=@rangeBody[i]+" "
                    a=Numtranser.new()
                    m << a.simpleMachine(st,dept+1)+"、"
                  end
                  list = @rangeTail.split("、")
                  if @rangeTail=="、"
                    list[0]=""
                  end
                  st = @rangeBody[-1]+list[0]+ " "
                  a=Numtranser.new()
                  m << a.simpleMachine(st,dept+1)+"、"
                  1.upto(list.size-1) do |i|
                      st = list[i]+ " "
                      a=Numtranser.new()
                      m << a.simpleMachine(st,dept+1)+"、"
                  end
                else
                #@result<<"daolaileffffffffffffffffffffffffff"+chongdie.to_s      
                  if chongdie== 1                  #十万二、三千零五十
                    @rangeBody.each do |body|
                    st=@rangeHead+body+@rangeTail+" "
                    a=Numtranser.new()
                    m << a.simpleMachine(st,dept+1)+"、"
                    end
                  else
                    st = @rangeHead + @rangeBody[0] + " "
                    a=Numtranser.new()
                    m << a.simpleMachine(st,dept+1)+"、"
                    width = @rangeBody.size - 2
                    1.upto(width) do |i|
                      st=@rangeBody[i]+" "
                      a=Numtranser.new()
                      m << a.simpleMachine(st,dept+1)+"、"
                    end
                    st = @rangeBody[-1]+@rangeTail+" "
                    a=Numtranser.new()
                    m << a.simpleMachine(st,dept+1)+"、"
                  end
                end

                m.chop!
               @result << highlight(@kanjitext,m)
               clear
             end
    end
    def highlight(str, value)
      "<a href='#' class='highlight' data-toggle='tooltip' title='#{value}'>#{str}</a>"
    end

    def get_transe4web(str)
      #a = highlight("100000","十万")
     #
      @result.clear
      autoMachine(str,0)
      #return "tian\r\n fjd \r\n"
    end

    def autoMachine(str,dept)
      clear
      @dept = dept
      @stubNum = str.count "、"
      str.gsub!(/分之/,'圙')
      str.gsub!(/好几/,'')
      str.gsub!(/几乎/,'ゑ')

      dian_pos=[]
      index=0
      while true
        timestamp =/[\d零一二三四五六七八九十两]+([点])[\d零一二三四五六七八九十两]+[分]/.match(str,index)
        if timestamp!=nil
          dian_pos<<timestamp.begin(1)
          index=timestamp.end(0)
        else
          break;
        end
      end
      dian_pos.each do |index|
        str[index]="㊔"
      end

      yu_pos=[]
      index=0
      while true
        yustamp =/[除|除以]+[\d零一二三四五六七八九十]+([余])[\d数零一二三四五六七八九十]/.match(str,index)
        if yustamp!=nil
          yu_pos<<yustamp.begin(1)
          index=yustamp.end(0)
        else
          break;
        end
      end
      yu_pos.each do |index|
        str[index]=""
      end
      # puts "line:"+@stubNum.to_s
      # if @stubNum >= 3
      #   @ordinal_numeral=1
      #   @noPrintOrderFlag = 1
      #   @stubFlag = 1
      # end
      str.each_char do |char|

        digit = $kanji['系数'][char]
        digit_pos = $kanji['数位'][char]
        digit_order = $kanji['阶位'][char]
        digit_origin = $kanji['数字'][char]
        extra_word = $kanji['附属词'][char]

        if digit!=nil || digit_pos!=nil || digit_order!=nil || digit_origin!=nil || extra_word!=nil
          if char == "圙" 
            @kanjitext << "分之"
          elsif char == "㊔"
            
          elsif char ==""
            @kanjitext << "好几"
          elsif char ==""
            @kanjitext << "余"
          else
            @kanjitext << char
          end 
        end

        if digit!=nil || digit_pos!=nil || digit_order!=nil || digit_origin!=nil || char=="点" || char == "圙"
          @kanjinumstring << char
        end

        case @stat
          when 0
            if digit != nil
              @moreOrLess="about " if char=="几" || char==""
              @stat = 1
              @num = digit
            elsif digit_pos != nil
              @stat = 2
              @num = 1*digit_pos
              @pos_value += @num
              @num = 0
            elsif  digit_order != nil
              @stat = 2
              @num = 1*digit_order
              @pos_value += @num
              @num = 0
            elsif digit_origin != nil
              #直接数字处理逻辑
              @stat = 1
              @numstringFlag = 1
              @numstring << char
              if @numstring.include?(".")
                @num = @numstring.to_f
              else
                @num = @numstring.to_i
              end
            # elsif char == "第"
            #   @ordinal_numeral = 1
            #   @stubFlag = 0
            #   @rangeHead << char
            # elsif char == "好"
            #   @moreOrLess = "more than "
            else
             char="点" if char=="㊔"
             char="分之" if char=="圙"
             char="好几" if char==""
             char="几乎" if char=="ゑ"
             char="余" if char==""
              @result << char 
              clear
            end
          when 1
            if digit_pos != nil
              if @rangeFlag == 1
                if !@numstring.empty?
                  @rangeBody << @numstring
                end
                @rangeFlag=2
                @rangeTail << char
                calcu_range(dept+1)
                @order = digit_pos/10
                @num *= digit_pos
                @pos_value += @num
                @num = 0
              else
                  @num *= digit_pos
                  if @num == 0
                    @num = 1*digit_pos
                  end
                  @pos_value += @num
                  @num = 0
                @order = digit_pos/10
                @stat = 3
                @numstring.clear
              end
            elsif digit_order != nil
              if @rangeFlag == 1
                if !@numstring.empty?
                  @rangeBody << @numstring
                end
                @rangeFlag=2
                @rangeTail << char
                @stat=11
                @order = digit_order/10
                @pos_value += @num
                @num = 0
                @order_value = @pos_value * digit_order
                @pos_value = 0
                @value += @order_value
                @order_value = 0
              else
                @stat = 4
                @order = digit_order/10
                @pos_value += @num
                @num = 0
                @order_value = @pos_value * digit_order
                @pos_value = 0
                @value += @order_value
                @order_value = 0
                @numstring.clear
              end
            elsif digit != nil       #连续数字
              
              if @numstringFlag == 1
                @value=@num
                # puts @numstring
                # puts @kanjinumstring
                @kanjinumstring=@kanjinumstring[@numstring.size..-1]
                #puts @kanjinumstring
                #puts @kanjitext
                @kanjitext=@kanjitext[@numstring.size..-1]
                @result << highlight(@numstring,@value)
                #puts @value
                @numstringFlag=0
                @numstring.clear
              end
              @num = digit
               if  @ordinal_numeral == 0
                if @zeroFlag == 0 && @rangeFlag == 0    #初次收集重叠项头、并产生重叠项
                  @rangeBody << @kanjinumstring[-2]
                  @rangeBody << @kanjinumstring[-1]
                  @kanjinumstring.chop!
                  @kanjinumstring.chop!
                  @rangeHead << @kanjinumstring
                  @kanjinumstring.clear
                  @rangeFlag = 1
                elsif @zeroFlag == 0 && @rangeFlag == 1  #继续收集重叠项
                  @rangeBody << @kanjinumstring[-1]
                  @kanjinumstring.chop!
                end

              end
            elsif digit_origin != nil
              @numstring << char
              @numstringFlag = 1
                if @numstring.include?(".")
                  @num = @numstring.to_f
                else
                  @num = @numstring.to_i
                end

            elsif char == "%"
              if @zeroFlag == 1
                @pos_value += @num
                @num = 0
                @zeroFlag = 0
              else
                @pos_value += @num * @order
                @num = 0
              end
              @order_value += @pos_value * 1
              @pos_value = 0
              @value += @order_value
              @order_value = 0
              @percentFlag = 1
              @kanjinumstring<<"%"
            elsif char == "/"
              if @zeroFlag == 1
                @pos_value += @num
                @num = 0
                @zeroFlag = 0
              else
                @pos_value += @num * @order
                @num = 0
              end
              @order_value += @pos_value * 1
              @pos_value = 0
              @value += @order_value
              @order_value = 0

              @denominator = @value
              @fractionFlag = 2
              @value = 0
              @numstring.clear
            elsif char == '点'
              @stat = 5
              @pos_value += @num
              @num = 0
              @order_value = @pos_value
              @pos_value = 0
              @value += @order_value
              @order_value = 0
              @int_part = @value
            elsif char =='圙'
              @stat = 10
              @fractionFlag = 1
            elsif char == "、"
              @stat = 7
            elsif  char == "来" || char == "多" #||char == "好" 
              @moreOrLess = "more than "
            elsif char == "余"
              @moreOrLess = "less than "
            else
              if @rangeFlag == 1
                if !@numstring.empty?
                  @rangeBody<<@numstring.clone
                end
                @rangeFlag=2
                @chuan = ""
                m=""
                if @rangeBody.size < 3
                  if @numstringEndFlag == 1
                    x = @rangeBody[1].to_i
                    y = @rangeBody[0].to_i
                  else
                    x =  $kanji['系数'][@rangeBody[1]]
                    y =  $kanji['系数'][@rangeBody[0]]
                  end
                  #puts "now2:"+@kanjitext
                  if  x - y == 1                  #十万二三千零五十
                    @rangeBody.each do |body|
                      st=@rangeHead+body+@rangeTail+" "
                      a=Numtranser.new()
                      m << a.simpleMachine(st,dept+1)+"、"
                    end
                  else                            #十三二万
                    st = @rangeHead + @rangeBody[0] + " "
                    a=Numtranser.new()
                    a.simpleMachine(st,dept+1)
                    width = @rangeBody.size - 2
                    1.upto(width) do |i|
                      st=@rangeBody[i]+" "
                      a=Numtranser.new()
                      m << a.simpleMachine(st,dept+1)+"、"
                    end
                  end
                  m.chop!
                  @result << highlight(@kanjitext,m)
                   char="点" if char=="㊔"
                   char="分之" if char=="圙"
                   char="好几" if char==""
                   char="几乎" if char=="ゑ"
                   char="余" if char==""
                   @result << char 
                  clear
                else
                  #puts "now4" + @kanjitext
                  @rangeBody.each do |body|
                    @chuan << $kanji['系数'][body].to_s
                  end
                  @result << highlight(@kanjitext,@chuan.clone)
                  clear

                end
                next
              end
              if @zeroFlag == 1
                @pos_value += @num
                @num = 0
                @zeroFlag = 0
              else
                @pos_value += @num * @order
                @num = 0
              end
              @order_value += @pos_value * 1
              @pos_value = 0
              @value += @order_value
              @order_value = 0
              if @fractionFlag == 1
                printFraction
                @fractionFlag = 0
              elsif @fractionFlag == 2
                printFraction2
                @fractionFlag = 0
              elsif @rangeFlag == 0
                printNum
              end
              char="点" if char=="㊔"
              char="分之" if char=="圙"
              char="好几" if char==""
              char="几乎" if char=="ゑ"
              char="余" if char==""
               @result << char 
            end
          when 2
            if digit != nil
              @moreOrLess="about " if char=="几" || char==""
              @num = digit
              @stat = 1
            elsif digit_pos != nil
              @order = digit_pos/10
              @pos_value *= digit_pos
              @stat = 2
            elsif digit_order != nil
              @order = digit_order/10
              @pos_value *= digit_order
              @stat = 2
            elsif digit_origin != nil
              @numstring << char
              @numstringFlag = 1
              if @numstring.include?(".")
                @num = @numstring.to_f
              else
                @num = @numstring.to_i
              end
              @stat = 1
            elsif char =='圙'
              @stat = 10
              @fractionFlag = 1
            elsif  char == "来" || char == "多" #||char == "好"
              @moreOrLess = "more than "
            elsif char == "余"
              @moreOrLess = "less than "
            elsif char == "、"
              @stat=7
            else
              @value += @pos_value
              @pos_value = 0
              if @fractionFlag == 1
                printFraction
                @fractionFlag = 0
              elsif @fractionFlag == 2
                printFraction2
                @fractionFlag = 0
              else
                printNum
              end
              char="点" if char=="㊔"
              char="分之" if char=="圙"
              char="好几" if char==""
              char="几乎" if char=="ゑ"
              char="余" if char==""
              @result << char 
              clear
            end
          when 3
            if digit_order != nil
              @order = digit_order/10
              @stat = 4
              @order_value = @pos_value * digit_order
              @pos_value = 0
              @value += @order_value
              @order_value = 0
            elsif digit_pos != nil
              @order = digit_pos/10
              @stat = 3
              @pos_value *= digit_pos
            elsif digit != nil
              @moreOrLess="about " if char=="几" || char==""
              @stat = 1
              if digit == 0
                @zeroFlag = 1
              end
              @num = digit
            elsif digit_origin != nil
              @numstring << char
              @numstringFlag = 1
              if @numstring.include?(".")
                @num = @numstring.to_f
              else
                @num = @numstring.to_i
              end
              @stat = 1
            elsif char == '点'
              @stat = 5
              @pos_value += @num
              @num = 0
              @order_value = @pos_value
              @pos_value = 0
              @value += @order_value
              @order_value = 0
              @int_part = @value
            elsif char =='圙'
              @stat = 10
              @fractionFlag = 1
            elsif char == "、"
              @stat = 7
            elsif  char == "来" || char == "多" #||char == "好"
                @moreOrLess = "more than "
            elsif char == "余"
                @moreOrLess = "less than "
            else
                @order_value = @pos_value * 1
                @pos_value = 0
                @value += @order_value
                @order_value = 0
                if @fractionFlag == 1
                  printFraction
                  @fractionFlag = 0
                elsif @fractionFlag == 2
                  printFraction2
                  @fractionFlag = 0
                else
                  printNum
                end
                char="点" if char=="㊔"
             char="分之" if char=="圙"
             char="好几" if char==""
             char="几乎" if char=="ゑ"
             char="余" if char==""
              @result << char 
              clear
            end
          when 4
            if digit != nil
              @moreOrLess="about " if char=="几" || char==""
              @stat = 1
              @num = digit
              if digit == 0
                @zeroFlag = 1
              end
            elsif digit_origin != nil
              @numstring << char
              @numstringFlag = 1
              if @numstring.include?(".")
                @num = @numstring.to_f
              else
                @num = @numstring.to_i
              end
              @stat = 1
            elsif digit_order != nil
              @value *= digit_order
            elsif char =='圙'
              @stat = 10
              @fractionFlag = 1
            elsif char == "、"
             @stat = 7
           else
            @order_value = @pos_value * 1
            @pos_value = 0
            @value += @order_value
            @order_value = 0
            if @fractionFlag == 1
              printFraction
              @fractionFlag = 0
            elsif @fractionFlag == 2
              printFraction2
              @fractionFlag = 0
            else
              printNum
            end
            char="点" if char=="㊔"
             char="分之" if char=="圙"
             char="好几" if char==""
             char="几乎" if char=="ゑ"
             char="余" if char==""
              @result << char 
            clear
           end
          when 5
            if digit != nil
              @moreOrLess="about " if char=="几" || char==""
              @stat = 6
              @decimal_part += digit.to_s
            elsif digit_origin != nil
              @stat = 6
              @decimal_part += char
            elsif char == "、"
              if @ordinal_numeral == 1
                @stat = 1
                st=@rangeHead+@kanjinumstring+" "

                a=Numtranser.new()
                a.autoMachine(st,dept+1)
                @decimal_part="."
                @kanjinumstring.clear
                @pos_value = 0
                @num = 0
                @order_value = 0
                @value = 0
                @numstring.clear   
              else
                @stat=7
              end
            end
          when 6
            if digit != nil
              @moreOrLess="about " if char=="几" || char==""
              @stat = 6
              @decimal_part += digit.to_s
            elsif digit_origin != nil
              @stat = 6
              @decimal_part += char
            elsif digit_pos != nil
              calcuFloat if @decimal_part.size != 0
              @stat = 6
              @value *= digit_pos
            elsif digit_order != nil
              calcuFloat if @decimal_part.size != 0
              @stat = 6
              @value *= digit_order
            elsif char == "、"
              if @ordinal_numeral == 1
                @stat = 1
                st=@rangeHead+@kanjinumstring+" "
                a=Numtranser.new()
                a.autoMachine(st,dept+1)
                @decimal_part="."
                @kanjinumstring.clear
                @pos_value = 0
                @num = 0
                @order_value = 0
                @value = 0
                @numstring.clear
              else
                @stat=7
              end
            elsif char =='圙'
              @stat = 10
              @fractionFlag = 1
            else
              if @fractionFlag == 1
                printFraction
                @fractionFlag = 0
              elsif @fractionFlag == 2
                printFraction2
                @fractionFlag = 0
              else
                calcuFloat if @decimal_part.size != 0
                printFloat
              end
             char="点" if char=="㊔"
             char="分之" if char=="圙"
             char="好几" if char==""
             char="几乎" if char=="ゑ"
             char="余" if char==""
               @result << char 
               clear
            end
          when 7
              if digit_origin!=nil
                  @bb=0
                  if @rangeFlag == 0    #初次收集重叠项头、并产生重叠项
                    alabostring=""
                    head_end=-2
                    (2..@kanjinumstring.size).step(1) do |i|
                      i*=-1
                      if @kanjinumstring[i] >= '0' && @kanjinumstring[i] <= '9'
                        alabostring << @kanjinumstring[i]
                      else
                        if alabostring.empty?
                          alabostring = @kanjinumstring[-2]
                        end
                        break
                      end
                    end
                    alabostring.reverse!
                     head_end=-1-alabostring.size
                    @rangeBody << alabostring
                    @rangeHead << @kanjinumstring[0...head_end].clone
                    @kanjinumstring.clear
                    @numstring.clear
                    #@numstring << char
                    @rangeFlag = 1
                  else          #继续收集
                    if @numstringFlag == 1
                      @numstring << char
                      @bb=1
                      @rangeBody << @numstring.clone
                      @numstringFlag = 0
                      @numstring.clear
                      @kanjinumstring.chop!
                    else
                      @chockFlag=1    
                      @rangeTail << char
                      @kanjinumstring.chop!
                    end
                  end
                  if @chockFlag != 1 && @bb==0
                    @numstringFlag = 1
                    @numstring << char
                    @kanjinumstring.chop!
                    @bb=1
                  end 
              elsif digit!=nil || digit_order!=nil || digit_pos!=nil || extra_word!=nil
                  if  @rangeFlag == 0    #初次收集重叠项头、并产生重叠项
                    alabostring=""
                    head_end=-2
                    (2..@kanjinumstring.size).step(1) do |i|
                      i*=-1
                      if @kanjinumstring[i] >= '0' && @kanjinumstring[i] <= '9'
                        alabostring << @kanjinumstring[i]
                      else
                        if alabostring.empty?
                          alabostring = @kanjinumstring[-2]
                        end
                        
                        break
                      end
                    end
                    alabostring.reverse!
                    head_end=-1-alabostring.size
                    @rangeHead << @kanjinumstring[0...head_end].clone
                    @rangeBody << alabostring
                    
                    @rangeBody << @kanjinumstring[-1]
                    @kanjinumstring.clear
                    @rangeFlag = 1
                    @numstring.clear
                    @numstringFlag = 0
                  elsif @rangeFlag == 1  #继续收集重叠项
                    if @numstringFlag == 1
                      #puts "ffffffffffffffffffff"+@numstring
                      @rangeBody << @numstring.clone
                      @numstringFlag = 0
                      @numstring.clear
                      @rangeTail << char
                      @kanjinumstring.chop!
                    else
                      @chockFlag=1    
                      @rangeTail << char
                      @kanjinumstring.chop!
                    end
                  end
              else
                if !@numstring.empty?
                  @rangeBody << @numstring.clone
                end
                 # @result << "================="
                 #  @result << "bogy:"+@rangeBody.to_s
                 #  @result << "tail:" + @rangeTail.to_s
                 #  @result << "================="
                 if @rangeFlag!=0
                   calcu_range(dept)
                 else
                   #@result << "here"+@order.to_s
                    if @zeroFlag == 1
                      @pos_value += @num
                      @num = 0
                      @zeroFlag = 0
                    else
                      @pos_value += @num * @order
                      @num = 0
                    end
                    @order_value += @pos_value * 1
                    @pos_value = 0
                    @value += @order_value
                    @order_value = 0
                 
                    if @fractionFlag == 1
                     printFraction
                      @fractionFlag = 0
                    elsif @fractionFlag == 2
                      printFraction2
                      @fractionFlag = 0
                    else
                       if @decimal_part.size > 1
                         calcuFloat 
                         printFloat
                       else
                         printNum
                       end
                    end
                 end
                
                char="点" if char=="㊔"
                char="分之" if char=="圙"
                char="好几" if char==""
                char="几乎" if char=="ゑ"
                char="余" if char==""
                 @result << char 
                 clear
              end
          when 8
             if  @ordinal_numeral == 0
                if @zeroFlag == 0 && @rangeFlag == 0    #初次收集重叠项头、并产生重叠项
                  @rangeBody << @kanjinumstring[-2]
                  @rangeBody << @kanjinumstring[-1]
                  @kanjinumstring.chop!
                  @kanjinumstring.chop!
                  @rangeHead << @kanjinumstring
                  @kanjinumstring.clear
                  @rangeFlag = 1
                elsif @zeroFlag == 0 && @rangeFlag == 1  #继续收集重叠项
                  @rangeBody << @kanjinumstring[-1]
                  @kanjinumstring.chop!
                end

              end
          when 9
          when 10
            if digit != nil
              @moreOrLess="about " if char=="几" || char==""
              @stat = 1
              @pos_value += @num
              @num = 0
              @order_value = @pos_value
              @pos_value = 0
              @value += @order_value
              @order_value = 0
              @int_part = @value
              temp = @int_part.to_s + @decimal_part
              if @decimal_part == "."
                @value = temp.to_i
              else
                @value = temp.to_f
              end
              @denominator = @value
              @value = 0
              @int_part = 0
              @decimal_part = "."
              @num = digit
            elsif char == "、"
              @stat = 7
            else
            end
        end
      end
      return @result
    end

    def simpleMachine(str,dept)
      clear
      @dept = dept
      str.gsub!(/分之/,'圙')
      dian_pos=[]
      index=0
      while true
        timestamp =/[\d零一二三四五六七八九十]+([点])[\d零一二三四五六七八九十]+[分]/.match(str,index)
        if timestamp!=nil
          dian_pos<<timestamp.begin(1)
          index=timestamp.end(0)
        else
          break;
        end
      end
      dian_pos.each do |index|
        str[index]="㊔"
      end
      str.each_char do |char|

        digit = $kanji['系数'][char]
        digit_pos = $kanji['数位'][char]
        digit_order = $kanji['阶位'][char]
        digit_origin = $kanji['数字'][char]
        extra_word = $kanji['附属词'][char]

        if digit!=nil || digit_pos!=nil || digit_order!=nil || digit_origin!=nil || extra_word!=nil
          if char == "圙" 
            @kanjitext << "分之"
          elsif char == "㊔"
            @kanjitext << ""
          else
            @kanjitext << char
          end 
        end

        if digit!=nil || digit_pos!=nil || digit_order!=nil || digit_origin!=nil || char=="点" || char == "圙"
          @kanjinumstring << char
        end

        case @stat
          when 0
            if digit != nil
              @stat = 1
              @num = digit
            elsif digit_pos != nil
              @stat = 2
              @num = 1*digit_pos
              @pos_value += @num
              @num = 0
            elsif  digit_order != nil
              @stat = 2
              @num = 1*digit_order
              @pos_value += @num
              @num = 0
            elsif digit_origin != nil
              #直接数字处理逻辑
              @stat = 1
              @numstringFlag = 1
              @numstring << char
              if @numstring.include?(".")
                @num = @numstring.to_f
              else
                @num = @numstring.to_i
              end
            # elsif char == "第"
            #   @ordinal_numeral = 1
            #   @stubFlag = 0
            #   @rangeHead << char
            # elsif char == "好"
            #   @moreOrLess = "more than "
            else
             char="点" if char=="㊔"
             char="分之" if char=="圙"
             char="好几" if char==""
             char="几乎" if char=="ゑ"
             char="余" if char==""
            @simpleResult << char 
              clear
            end
          when 1
            if digit_pos != nil
              if @rangeFlag == 1
                if !@numstring.empty?
                  @rangeBody << @numstring
                end
                @rangeFlag=2
                @rangeTail << char
                @stat=11
                @order = digit_pos/10
                @num *= digit_pos
                @pos_value += @num
                @num = 0
              else
                  @num *= digit_pos
                  if @num == 0
                    @num = 1*digit_pos
                  end
                  @pos_value += @num
                  @num = 0
                @order = digit_pos/10
                @stat = 3
                @numstring.clear
              end
            elsif digit_order != nil
              if @rangeFlag == 1
                if !@numstring.empty?
                  @rangeBody << @numstring
                end
                @rangeFlag=2
                @rangeTail << char
                @stat=11
                @order = digit_order/10
                @pos_value += @num
                @num = 0
                @order_value = @pos_value * digit_order
                @pos_value = 0
                @value += @order_value
                @order_value = 0
              else
                @stat = 4
                @order = digit_order/10
                @pos_value += @num
                @num = 0
                @order_value = @pos_value * digit_order
                @pos_value = 0
                @value += @order_value
                @order_value = 0
                @numstring.clear
              end
            elsif digit != nil       #连续数字
              
              if @numstringFlag == 1
                @value=@num
                # puts @numstring
                # puts @kanjinumstring
                @kanjinumstring=@kanjinumstring[@numstring.size..-1]
                #puts @kanjinumstring
                #puts @kanjitext
                @kanjitext=@kanjitext[@numstring.size..-1]
                @simpleResult << highlight(@numstring,@value)
                #puts @value
                @numstringFlag=0
                @numstring.clear
              end
              @num = digit
               if  @ordinal_numeral == 0
                if @zeroFlag == 0 && @rangeFlag == 0    #初次收集重叠项头、并产生重叠项
                  @rangeBody << @kanjinumstring[-2]
                  @rangeBody << @kanjinumstring[-1]
                  @kanjinumstring.chop!
                  @kanjinumstring.chop!
                  @rangeHead << @kanjinumstring
                  @kanjinumstring.clear
                  @rangeFlag = 1
                elsif @zeroFlag == 0 && @rangeFlag == 1  #继续收集重叠项
                  @rangeBody << @kanjinumstring[-1]
                  @kanjinumstring.chop!
                end

              end
            elsif digit_origin != nil
              @numstring << char
              @numstringFlag = 1
                if @numstring.include?(".")
                  @num = @numstring.to_f
                else
                  @num = @numstring.to_i
                end

            elsif char == "%"
              if @zeroFlag == 1
                @pos_value += @num
                @num = 0
                @zeroFlag = 0
              else
                @pos_value += @num * @order
                @num = 0
              end
              @order_value += @pos_value * 1
              @pos_value = 0
              @value += @order_value
              @order_value = 0
              @percentFlag = 1
            elsif char == "/"
              if @zeroFlag == 1
                @pos_value += @num
                @num = 0
                @zeroFlag = 0
              else
                @pos_value += @num * @order
                @num = 0
              end
              @order_value += @pos_value * 1
              @pos_value = 0
              @value += @order_value
              @order_value = 0

              @denominator = @value
              @fractionFlag = 2
              @value = 0
              @numstring.clear
            elsif char == '点'
              @stat = 5
              @pos_value += @num
              @num = 0
              @order_value = @pos_value
              @pos_value = 0
              @value += @order_value
              @order_value = 0
              @int_part = @value
            elsif char =='圙'
              @stat = 10
              @fractionFlag = 1
            elsif char == "、"
              @stat = 7
            elsif char == "来" || char == "多" # ||char == "好"
              @moreOrLess = "more than "
            elsif char == "余"
              @moreOrLess = "less than "
            else
              if @rangeFlag == 1
                if !@numstring.empty?
                  @rangeBody<<@numstring.clone
                end
                @rangeFlag=2
                @chuan = ""
                if @rangeBody.size < 3
                  if @numstringEndFlag == 1
                    x = @rangeBody[1].to_i
                    y = @rangeBody[0].to_i
                  else
                    x =  $kanji['系数'][@rangeBody[1]]
                    y =  $kanji['系数'][@rangeBody[0]]
                  end
                  puts "now2:"+@kanjitext
                  if  x - y == 1                  #十万二三千零五十
                    @rangeBody.each do |body|
                      st=@rangeHead+body+@rangeTail+" "
                      a=Numtranser.new()
                      a.autoMachine(st,dept+1)
                    end
                  else                            #十三二万
                    st = @rangeHead + @rangeBody[0] + " "
                    a=Numtranser.new()
                    a.autoMachine(st,dept+1)
                    width = @rangeBody.size - 2
                    1.upto(width) do |i|
                      st=@rangeBody[i]+" "
                      a=Numtranser.new()
                      a.autoMachine(st,dept+1)
                    end
                  end
                  clear
                else
                  puts "now4" + @kanjitext
                  @rangeBody.each do |body|
                    @chuan << $kanji['系数'][body].to_s
                  end
                  puts @chuan
                  clear
                end
                next
              end
              if @zeroFlag == 1
                @pos_value += @num
                @num = 0
                @zeroFlag = 0
              else
                @pos_value += @num * @order
                @num = 0
              end
              @order_value += @pos_value * 1
              @pos_value = 0
              @value += @order_value
              @order_value = 0
              if @fractionFlag == 1
                @simpleResult << simple_printFraction
                @fractionFlag = 0
              elsif @fractionFlag == 2
                @simpleResult << simple_printFraction2
                @fractionFlag = 0
              elsif @rangeFlag == 0
                @simpleResult << simple_printNum
              end
              char="点" if char=="㊔"
              char="分之" if char=="圙"
              char="好几" if char==""
              char="几乎" if char=="ゑ"
              char="余" if char==""
               @simpleResult << char 
            end
          when 2
            if digit != nil
              @num = digit
              @stat = 1
            elsif digit_pos != nil
              @order = digit_pos/10
              @pos_value *= digit_pos
              @stat = 2
            elsif digit_order != nil
              @order = digit_order/10
              @pos_value *= digit_order
              @stat = 2
            elsif digit_origin != nil
              @numstring << char
              @numstringFlag = 1
              if @numstring.include?(".")
                @num = @numstring.to_f
              else
                @num = @numstring.to_i
              end
              @stat = 1
            elsif char =='圙'
              @stat = 10
              @fractionFlag = 1
            elsif  char == "来" || char == "多" #|| char == "好"
              @moreOrLess = "more than "
            elsif char == "余"
              @moreOrLess = "less than "
            else
              @value += @pos_value
              @pos_value = 0
              if @fractionFlag == 1
                @simpleResult << simple_printFraction
                @fractionFlag = 0
              elsif @fractionFlag == 2
                @simpleResult << simple_printFraction2
                @fractionFlag = 0
              else
                @simpleResult << simple_printNum
              end
              char="点" if char=="㊔"
             char="分之" if char=="圙"
             char="好几" if char==""
             char="几乎" if char=="ゑ"
             char="余" if char==""
              @simpleResult << char 
              clear
            end
          when 3
            if digit_order != nil
              @order = digit_order/10
              @stat = 4
              @order_value = @pos_value * digit_order
              @pos_value = 0
              @value += @order_value
              @order_value = 0
            elsif digit_pos != nil
              @order = digit_pos/10
              @stat = 3
              @pos_value *= digit_pos
            elsif digit != nil
              @stat = 1
              if digit == 0
                @zeroFlag = 1
              end
              @num = digit
            elsif digit_origin != nil
              @numstring << char
              @numstringFlag = 1
              if @numstring.include?(".")
                @num = @numstring.to_f
              else
                @num = @numstring.to_i
              end
              @stat = 1
            elsif char == '点'
              @stat = 5
              @pos_value += @num
              @num = 0
              @order_value = @pos_value
              @pos_value = 0
              @value += @order_value
              @order_value = 0
              @int_part = @value
            elsif char =='圙'
              @stat = 10
              @fractionFlag = 1
            elsif char == "、"
              @stat = 7
            elsif  char == "来" || char == "多" #|| char == "好"
                @moreOrLess = "more than "
            elsif char == "余"
                @moreOrLess = "less than "
            else
                @order_value = @pos_value * 1
                @pos_value = 0
                @value += @order_value
                @order_value = 0
                if @fractionFlag == 1
                  @simpleResult << simple_printFraction
                  @fractionFlag = 0
                elsif @fractionFlag == 2
                  @simpleResult << simple_printFraction2
                  @fractionFlag = 0
                else
                  @simpleResult << simple_printNum
                end
                char="点" if char=="㊔"
             char="分之" if char=="圙"
             char="好几" if char==""
             char="几乎" if char=="ゑ"
             char="余" if char==""
              @simpleResult << char 
              clear
            end
          when 4
            if digit != nil
              @stat = 1
              @num = digit
              if digit == 0
                @zeroFlag = 1
              end
            elsif digit_origin != nil
              @numstring << char
              @numstringFlag = 1
              if @numstring.include?(".")
                @num = @numstring.to_f
              else
                @num = @numstring.to_i
              end
              @stat = 1
            elsif digit_order != nil
              @value *= digit_order
            elsif char =='圙'
              @stat = 10
              @fractionFlag = 1
            elsif char == "、"
             @stat = 7
           else
            @order_value = @pos_value * 1
            @pos_value = 0
            @value += @order_value
            @order_value = 0
            if @fractionFlag == 1
              @simpleResult << simple_printFraction
              @fractionFlag = 0
            elsif @fractionFlag == 2
              @simpleResult << simple_printFraction2
              @fractionFlag = 0
            else
              @simpleResult << simple_printNum
            end
            char="点" if char=="㊔"
             char="分之" if char=="圙"
             char="好几" if char==""
             char="几乎" if char=="ゑ"
             char="余" if char==""
            @simpleResult << char 
            clear
           end
          when 5
            if digit != nil
              @stat = 6
              @decimal_part += digit.to_s
            elsif digit_origin != nil
              @stat = 6
              @decimal_part += char
            elsif char == "、"
              if @ordinal_numeral == 1
                @stat = 1
                st=@rangeHead+@kanjinumstring+" "

                a=Numtranser.new()
                a.autoMachine(st,dept+1)
                @decimal_part="."
                @kanjinumstring.clear
                @pos_value = 0
                @num = 0
                @order_value = 0
                @value = 0
                @numstring.clear
              else
                @stat=7
              end

            end
          when 6
            if digit != nil
              @stat = 6
              @decimal_part += digit.to_s
            elsif digit_origin != nil
              @stat = 6
              @decimal_part += char
            elsif digit_pos != nil
              calcuFloat if @decimal_part.size != 0
              @stat = 6
              @value *= digit_pos
            elsif digit_order != nil
              calcuFloat if @decimal_part.size != 0
              @stat = 6
              @value *= digit_order
            elsif char == "、"
              if @ordinal_numeral == 1
                @stat = 1
                st=@rangeHead+@kanjinumstring+" "
                a=Numtranser.new()
                a.autoMachine(st,dept+1)
                @decimal_part="."
                @kanjinumstring.clear
                @pos_value = 0
                @num = 0
                @order_value = 0
                @value = 0
                @numstring.clear
              else
                @stat=7
              end
            elsif char =='圙'
              @stat = 10
              @fractionFlag = 1
            else
              if @fractionFlag == 1
                @simpleResult << simple_printFraction
                @fractionFlag = 0
              elsif @fractionFlag == 2
                @simpleResult << simple_printFraction2
                @fractionFlag = 0
              else
                calcuFloat if @decimal_part.size != 0
                @simpleResult << simple_printFloat
              end
              char="点" if char=="㊔"
             char="分之" if char=="圙"
             char="好几" if char==""
             char="几乎" if char=="ゑ"
             char="余" if char==""
               @simpleResult << char 
            end
          when 7
              if digit_origin!=nil
                  @bb=0
                  if @rangeFlag == 0    #初次收集重叠项头、并产生重叠项
                    alabostring=""
                    head_end=-2
                    (2..@kanjinumstring.size).step(1) do |i|
                      i*=-1
                      if @kanjinumstring[i] >= '0' && @kanjinumstring[i] <= '9'
                        alabostring << @kanjinumstring[i]
                      else
                        if alabostring.empty?
                          alabostring = @kanjinumstring[-2]
                        end
                        break
                      end
                    end
                    alabostring.reverse!
                     head_end=-1-alabostring.size
                    @rangeBody << alabostring
                    @rangeHead << @kanjinumstring[0...head_end].clone
                    @kanjinumstring.clear
                    @numstring.clear
                    @rangeFlag = 1
                  else
                    if @numstringFlag == 1
                      @numstring << char
                      @bb=1
                      @rangeBody << @numstring.clone
                      @numstringFlag = 0
                      @numstring.clear
                      
                      @kanjinumstring.chop!
                    else
                      @chockFlag=1    
                      @rangeTail << char
                      @kanjinumstring.chop!
                    end
                  end
                  if @chockFlag != 1 && @bb==0
                    @numstringFlag = 1
                    @numstring << char
                    @kanjinumstring.chop!
                    @bb=1
                  end 
              elsif digit!=nil || digit_order!=nil || digit_pos!=nil || extra_word!=nil
                  if  @rangeFlag == 0    #初次收集重叠项头、并产生重叠项
                    alabostring=""
                    head_end=-2
                    (2..@kanjinumstring.size).step(1) do |i|
                      i*=-1
                      if @kanjinumstring[i] >= '0' && @kanjinumstring[i] <= '9'
                        alabostring << @kanjinumstring[i]
                      else
                        if alabostring.empty?
                          alabostring = @kanjinumstring[-2]
                        end
                        
                        break
                      end
                    end
                    alabostring.reverse!
                    head_end=-1-alabostring.size
                    @rangeHead << @kanjinumstring[0...head_end].clone
                    @rangeBody << alabostring
                    
                    @rangeBody << @kanjinumstring[-1]
                    @kanjinumstring.clear
                    @rangeFlag = 1
                    @numstring.clear
                    @numstringFlag = 0
                  elsif @rangeFlag == 1  #继续收集重叠项
                    if @numstringFlag == 1
                      #puts "ffffffffffffffffffff"+@numstring
                      @rangeBody << @numstring.clone
                      @numstringFlag = 0
                      @numstring.clear
                      @rangeTail << char
                      @kanjinumstring.chop!
                    else
                      @chockFlag=1    
                      @rangeTail << char
                      @kanjinumstring.chop!
                    end
                  end
              else
               if !@numstring.empty?
                  @rangeBody << @numstring.clone
                end
                 # @result << "================="
                 #  @result << "bogy:"+@rangeBody.to_s
                 #  @result << "tail:" + @rangeTail.to_s
                 #  @result << "================="
                 if @rangeFlag!=0
                   calcu_range(dept)
                 else
                   #@result << "here"+@order.to_s
                    if @zeroFlag == 1
                      @pos_value += @num
                      @num = 0
                      @zeroFlag = 0
                    else
                      @pos_value += @num * @order
                      @num = 0
                    end
                    @order_value += @pos_value * 1
                    @pos_value = 0
                    @value += @order_value
                    @order_value = 0
                 
                    if @fractionFlag == 1
                      printFraction
                      @fractionFlag = 0
                    elsif @fractionFlag == 2
                      printFraction2
                      @fractionFlag = 0
                    else
                       if @decimal_part.size > 1
                         calcuFloat 
                         printFloat
                       else
                         printNum
                       end
                    end
                 end
                
                char="点" if char=="㊔"
                char="分之" if char=="圙"
                char="好几" if char==""
                char="几乎" if char=="ゑ"
                char="余" if char==""
                 @simpleResult << char 
                 clear
              end
          when 8
             if  @ordinal_numeral == 0
                if @zeroFlag == 0 && @rangeFlag == 0    #初次收集重叠项头、并产生重叠项
                  @rangeBody << @kanjinumstring[-2]
                  @rangeBody << @kanjinumstring[-1]
                  @kanjinumstring.chop!
                  @kanjinumstring.chop!
                  @rangeHead << @kanjinumstring
                  @kanjinumstring.clear
                  @rangeFlag = 1
                elsif @zeroFlag == 0 && @rangeFlag == 1  #继续收集重叠项
                  @rangeBody << @kanjinumstring[-1]
                  @kanjinumstring.chop!
                end

              end
          when 9
          when 10
            if digit != nil
              @stat = 1
              @pos_value += @num
              @num = 0
              @order_value = @pos_value
              @pos_value = 0
              @value += @order_value
              @order_value = 0
              @int_part = @value
              temp = @int_part.to_s + @decimal_part
              if @decimal_part == "."
                @value = temp.to_i
              else
                @value = temp.to_f
              end
              @denominator = @value
              @value = 0
              @int_part = 0
              @decimal_part = "."
              @num = digit
            elsif char == "、"
              @stat = 7
            else
            end
        end
      end
       return @simpleResult.clone
    end

end

begin
  a=Numtranser.new()

  a.scanner_file
end