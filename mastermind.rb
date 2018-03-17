class Game

def initialize
  @arraycolors=["green","red","yellow","brown","gray","orange"]
  @board=[]
  @boardResults=[]
  @secretCode=[]
  @tries=12
  @codebreaker=""
  @answerCode=[]
  @compareCode=[]

end


def roles
  result=""
  loop do

  puts "Please let me know if you  will be codebreaker (Yes/No)"
  result=gets.chomp
    if (result.upcase=="YES") || (result.upcase=="NO")
      break
    else
      puts "Sorry!!! , cuold you repeat"
    end
  end

    if result.upcase=="YES"

      puts "Please let me know your name "
      @codebreaker=gets.chomp
      puts "Thanks   #{@codebreaker}"

    else
      @codebreaker="ROBOT"
      @r=Robot.new

    end

end


def getColors
  color=""
    loop do
      puts "Please select a color from the colors available"
      puts @arraycolors.inspect
      color=gets.chomp
      color.downcase!
      if @arraycolors.include? color.downcase
        break
      else
        puts "Sorry!!! , cuold you repeat"
      end
    end
    color
end

def newcode
  if (@codebreaker !="ROBOT" )
    4.times do
      @secretCode << @arraycolors[rand(0...6)]
    end

  else
    puts "Please define the secret code "
    4.times do
      @secretCode << getColors
    end

  end
  puts "Secret Code is  #{@secretCode}"
end


def checkCode(j)



    @compareCode=[]
    for i in (0...4)  do
      if @secretCode.include? @answerCode[j][i]
          if @answerCode[j][i]==@secretCode[i]
            @compareCode << "+"
          else
             if ((@secretCode.join.count  @answerCode[j][i]) >= (@answerCode[j].join.count @answerCode[j][i]))
                @compareCode <<"o"
              else
                @compareCode << "-"
              end
          end
        else
            @compareCode << "-"
      end
    end
    if (@compareCode.join.count "+") == 4
        result=true
      else
        result=false
    end
    @answerCode[j] << @compareCode
    result
end

def answer(i)
    temporal=[]

  if (@codebreaker !="ROBOT" )
    puts "Please #{@codemaker} insert your 4 colors  "
    4.times do
      temporal << getColors
    end
      puts "Your guess is #{temporal}"
  else
    temporal=@r.thinking(@answerCode,i,@secretCode,@arraycolors)
  end
  @answerCode[i]= temporal
end


def printboard(i)
    puts "Current Mastermind Status "
    puts " #{@codebreaker}   you have #{@tries-i}  oportinities more"
    @answerCode.each_with_index { |x,indx|
       print " #{@answerCode[indx]}  "
     puts "" }






end

def play
  roles
  newcode
  i=0

    loop do
      answer(i)
      if checkCode(i)
        puts "Congratulations #{@codebreaker} you Win!!!"
          printboard(i+=1)
        break
      end
      printboard(i+=1)

      if (( i>= @tries) )
        break
      end
      s=gets.chomp
     end

     if (i== @tries)
       puts "Sorry #{@codebreaker} you lost!!!"
       puts "Secret Code was  #{@secretCode}"
     end


end

end


class Robot
@vocabulary = ["chirps his excitement", "beeps", "Uyyyy","chirps confidently",
  "bleep bleep bloop", "bleep blopp beep beep", "beep beep","Opsssss"]

  def initialize
    @name="Robotin"
    puts "Hello, my name is  #{@name}"
  end

  def talk
    puts "#{@name} - #{@vocabulary.sample}"
  end


def randomColor(list,colors,color)
  sample=color
  while (color ==sample) do
      sample=list.sample
      if sample== color
        sample=colors[rand(0...6)]
      end
  end
  sample.to_s
end

def randomColorList(list,colors)
  sample=""
  #puts "Emntra list #{list}"

  loop  do
        sample=colors[rand(0...6)]
        if (not (list.include? sample) )
          break
        end
  end
  #puts "sale #{sample}"
  #s=gets.chomp
  sample.to_s
end

  def thinking(array,i,secret,colors )
    result=[]
    resultpos=[]
    temporallistcolors=[]
    guess=""
    currentcolor=[]


    #puts "Estamso en Thinking"
    pos  = Struct.new(:color ,:res,:position)
    total=Array.new
    if i== 0
      4.times do
        result << colors[rand(0...6)]
      end
    else
      #j=i-1
      for j in (0...i) do
          for l in (0...4) do
            p=pos.new
            p.color=array[j][l]
            p.res=array[j][4][l]
            p.position=l
            total.push(p)
          end
      end
      #j=i-1
      total=total.sort_by {|a| [a.position,a.res] }
      for k in (0...4) do
          resultpos.clear
          temporallistcolors=[]
          guess=""
          currentcolor.clear



          resultpos=total.select{|x|  x.res=="o"}
          #puts "conenido de resultadopos #{resultpos}"
          resultpos.map.with_index {|x,i| temporallistcolors << x.color}
          resultpos.clear
          resultpos=total.select {|x| x.position==k && x.res=="+"}

          if resultpos.empty?
              resultpos=total.select{|x| x.position==k && x.res=="o"}

              if resultpos.empty?
                    resultpos=total.select{|x| x.position==k && x.res=="-"}
                    #puts "Este es el varo de  temporallistcolors cuando -----  #{temporallistcolors}"
                    #puts "conenido de resultadopos cuando ----- #{resultpos}"
                    temporallistcolors=[]
                    resultpos=total.select{|x|  x.position==k && x.res=="o"}
                    #puts "conenido de resultadopos #{resultpos}"
                    resultpos.map.with_index {|x,i| temporallistcolors << x.color}

                    if (not (resultpos.empty? )) &&   (temporallistcolors.size > 0)

                      result << temporallistcolors.sample
                    #  puts "conenido de Result si entrs cuando ----- #{result}"
                    else
                      resultpos=total.select{|x|  x.position==k && x.res=="-"}
                      #
                      temporallistcolors=[]
                      resultpos.map.with_index {|x,i| temporallistcolors << x.color}
                      result << randomColorList(temporallistcolors,colors)
                    #    puts "conenido de Result NO entrs cuando ----- #{result}"
                    end
              else
                  #mejorar
                    resultpos=total.select {|x| x.position==k }
                    temporallistcolors=[]
                    resultpos.map.with_index {|x,i| temporallistcolors << x.color}

                    guess =randomColorList(temporallistcolors,colors)

                    #puts "Este es el varo de  temporallistcolors #{temporallistcolors}"
                    #puts "ESte es e guess #{guess}"
                    #puts "Este es el valor cel color en la posicion #{currentcolor[0].color}"
                    #puts "valor de K #{k}"

                    #puts "Agregando color #{guess}"
                    result << guess
                    #puts "Result va en #{result}"

              end
          else
            result << resultpos.fetch(0).color
          end
      end
    end
    #puts "Result en lo que devuelve  #{result}"
    result
  end

end

j=Game.new
j.play
