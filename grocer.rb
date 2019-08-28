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
    if consol_cart[coupon_hash[:item]]
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