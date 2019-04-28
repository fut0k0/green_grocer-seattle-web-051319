def consolidate_cart(cart)
	#create consolidated cart hash
	cons_cart = {}
	
	#populate consolidated cart hash, including item counts
	cart.each do |item|
		item.each do |name, details|
			if cons_cart[name].nil?
				cons_cart[name] = details
				cons_cart[name][:count] = 1
			else
				cons_cart[name][:count] += 1
			end	
		end	
	end	
	
	cons_cart
end

def apply_coupons(cart, coupons)
	#apply coupons to applicable items & update cart
	coupons.each do |coupon|
		if cart.keys.include?(coupon[:item])
			if coupon[:num] <= cart[coupon[:item]][:count]
				cart[coupon[:item] + " W/COUPON"] ||= {}
				cart[coupon[:item] + " W/COUPON"][:price] = coupon[:cost]
				cart[coupon[:item] + " W/COUPON"][:clearance] = cart[coupon[:item]][:clearance]
				cart[coupon[:item] + " W/COUPON"][:count] ||= 0
				cart[coupon[:item] + " W/COUPON"][:count] += 1
				cart[coupon[:item]][:count] -= coupon[:num]
			end	
		end	
	end
	
	cart
end

def apply_clearance(cart)
	#apply clearance prices to applicable items
	cart.each do |name, details|
		details[:price] = (0.8 * details[:price]).round(2) if details[:clearance]
	end	
	
	cart
end

def checkout(cart, coupons)
	#create total_cost tracker
	total_cost = 0.00
	
	#process cart through consolidation, coupons, & clearance
	proc_cart = apply_clearance(apply_coupons(consolidate_cart(cart), coupons))
	
	#compute total cost of processed cart & apply 10% discount for large totals
	proc_cart.each {|name, details| total_cost += details[:price] * details[:count]}
	total_cost = 0.9 * total_cost if total_cost > 100.00
	
	total_cost	 
end