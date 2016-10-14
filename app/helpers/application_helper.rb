module ApplicationHelper
	
	def nagivation_list(count, per_page, cur_page)
		@no_of_paginations = (@count.fdiv(@per_page)).ceil
		
		if @cur_page >= 7 
			@start_loop = @cur_page - 3
			if @no_of_paginations > @cur_page + 3
				@end_loop = @cur_page + 3
			elsif @cur_page <= @no_of_paginations && @cur_page > @no_of_paginations - 6
				@start_loop = @no_of_paginations - 6
				@end_loop = @no_of_paginations
			else
				@end_loop = @no_of_paginations
			end
		else
			@start_loop = 1
			if @no_of_paginations > 7
				@end_loop = 7
			else
				@end_loop = @no_of_paginations
			end
		end

		# Pagination Buttons logic     
		@pagination_nav += "
			<div class='pagination-container'>
				<ul>"

		if @first_btn && @cur_page > 1
			@pagination_nav += "<li p='1' class='active'>First</li>"
		elsif @first_btn
			@pagination_nav += "<li p='1' class='inactive'>First</li>"
		end

		if @previous_btn && @cur_page > 1
			@pre = @cur_page - 1
			@pagination_nav += "<li p='#{@pre}' class='active'>Previous</li>"
		elsif @previous_btn
			@pagination_nav += "<li class='inactive'>Previous</li>"
		end
		
		for @i in @start_loop..@end_loop do
			if @cur_page == @i
				@pagination_nav += "<li p='#{@i}' class = 'selected'>#{@i}</li>"
			else
				@pagination_nav += "<li p='#{@i}' class='active'>#{@i}</li>"
			end
		end

		if @next_btn && @cur_page < @no_of_paginations
			@nex = @cur_page + 1
			@pagination_nav += "<li p='#{@nex}' class='active'>Next</li>"
		elsif @next_btn
			@pagination_nav += "<li class='inactive'>Next</li>"
		end

		if @last_btn && @cur_page < @no_of_paginations
			@pagination_nav += "<li p='#{@no_of_paginations}' class='active'>Last</li>"
		elsif @last_btn
			@pagination_nav += "<li p='#{@no_of_paginations}' class='inactive'>Last</li>"
		end

		@pagination_nav = "#{@pagination_nav}
				</ul>
			</div>"
	end
	
end
