def parseCalcProblems(filename)
  file = File.open(filename, 'rb')
  hash = {}
  toggle = 0
  current_q = ""
  current_r = ""
  current_g = "" #current grouping.. ie, first two digits
  
  file.each do |line|
    if line[0] == "q"
      current_g = line[1..2]
      current_q = line[3..4]
      current_r = line[5..6]
      toggle = 1
      if !hash.has_key?("g#{current_g}")
        #hash["g#{current_g}"] = { "group_id" => "g#{current_g}" }
        hash["g#{current_g}"] = {}
      end
      if !hash["g#{current_g}"].has_key?("q#{current_q}")
        hash["g#{current_g}"]["q#{current_q}"] = { "question_id" => "q#{current_g}#{current_q}"}
        #hash["g#{current_g}"]["q#{current_q}"] = {}
      end
    else
      next unless toggle == 1
      if current_r[0] == "\\"
        hash["g#{current_g}"]["q#{current_q}"].merge!({"text" => line.delete("\n")})
      elsif current_r[0] == "r"
        hash["g#{current_g}"]["q#{current_q}"].merge!({"#{current_r}" => line.delete("\n")})
      end
      toggle = 0
    end
  end
  
  file.close()
  return hash
end



def calcToTSV(filename, output_path)
  hash = parseCalcProblems(filename)
  
  file = File.open(output_path, 'w')
  hash.each do |gKey, gVal|
    gVal.each do |qKey, qValue|
      out = "\t#{qValue['text']}\t#{qValue['r1']}\t#{qValue['r2']}\t#{qValue['r3']}\t#{qValue['r4']}\t\t#{qValue['question_id']}\n"
      #puts out       #haha gotta buy dinner first...
      file.write(out)
      #Note: this will not work on Heroku b/c you can't write to disk in a Rake task... so parse locally!
    end
  end
  file.close()
  return nil
end






