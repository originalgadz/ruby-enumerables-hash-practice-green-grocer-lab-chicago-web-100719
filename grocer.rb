require 'pry'

def consolidate_cart(cart)
  consol_cart = {}
  cart.each do |cart_hash|
    cart_hash.each do |cart_item, item_pricing|
      if consol_cart[cart_item]
        consol_cart[cart_item][:count] += 1
      else
        consol_cart[cart_item] = item_pricing
        consol_cart[cart_item][:count] = 1
      end
    end
  end
  return consol_cart
end

def apply_coupons (consol_cart, coupons)
  coupons.each do |coupon_hash|
    if consol_cart[coupon_hash[:item]] && coupon_hash[:num] <= consol_cart[coupon_hash[:item]][:count]
      new_item = coupon_hash[:item] + " W/COUPON"
      if consol_cart[new_item]
        consol_cart[new_item][:count] += coupon_hash[:num]
      else consol_cart[new_item] = {
        :price => coupon_hash[:cost]/coupon_hash[:num],
        :clearance => consol_cart[coupon_hash[:item]][:clearance],
        :count => coupon_hash[:num]
      }
      end
      consol_cart[coupon_hash[:item]][:count] -= coupon_hash[:num]
    end
  end
  return consol_cart
end

def apply_clearance (cart)
  cart.each do |item, price_data|
    if price_data[:clearance]
      price_data[:price] = (price_data[:price] * 0.8).round(2)
    end
  end
  return cart
end

def checkout (cart, coupons = 0)
  total_cost = 0.00
  total_cart =[]
  total_cart = consolidate_cart(cart)
  if coupons != 0
    total_cart = apply_coupons(total_cart, coupons)
  end
  total_cart = apply_clearance(total_cart)
  total_cart.each do |item, price_data|
    total_cost = total_cost + (price_data[:price] * price_data[:count])
  end
  if total_cost > 100
    total_cost = (total_cost * 0.9).round(2)
  end
  return total_cost
end
