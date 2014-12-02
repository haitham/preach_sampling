#This script runs the program with the following arguments, creates plottable datafiles for the results and a gnuplot script to plot them
dataset, prob_start, prob_end, prob_step, sample_start, sample_end, sample_step = ARGV
prob_start = prob_start.to_f
prob_end = prob_end.to_f
prob_step = prob_step.to_f
sample_start = sample_start.to_i
sample_end = sample_end.to_i
sample_step = sample_step.to_i
puts sample_step

sample = sample_start
until sample > sample_end
	prob = prob_start
	until prob > prob_end
		puts "running: #{dataset} #{prob} #{sample}"
		#result = "#asfd\n#asfdsf\n5 4 0.8\n6 5 0.7\n"
		result = `../preach #{dataset}/network.txt #{dataset}/sources.txt #{dataset}/targets.txt #{prob} #{sample}`
		lines = result.split("\n").reject{|l| l =~ /^#/}
		if lines.size != sample
			prob = prob + prob_step
			next
		end
		values = lines.map{|l| l.split.last.to_f}
		avg = values.reduce(:+)/values.size
		stdev = Math.sqrt(values.map{|v| (v-avg)*(v-avg)}.reduce(:+)/values.size)
		open("#{dataset}/results_#{prob}_#{sample}.out", "w"){|f| f.puts values.join("\n")}
		open("#{dataset}/mean_#{prob}_#{sample}.out", "w"){|f| f.puts ["0.0", "1.0"].map{|v| "#{avg} #{v}"}.join("\n")}
		open("#{dataset}/dev_#{prob}_#{sample}.out", "w"){|f| f.puts "#{avg} 1.0 #{avg-stdev} #{avg+stdev}"}
		prob = prob + prob_step
	end
	sample = sample + sample_step
end