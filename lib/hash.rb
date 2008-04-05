class Hash
  # Return a new hash with all keys converted to integers.
  def integerize_keys
     inject({}) do |options, (key, value)|
       options[key.to_i] = value
       options
     end
   end

   # Destructively convert all keys to integers.
   def integerize_keys!
     keys.each do |key|
       unless key.in_a?(Integer)
         self[key.to_i] = self[key]
         delete(key)
       end
     end
     self
   end
   
   # Sorting a hash turns it into an array of arrays.
   # Do that and drop off the key
   def to_sorted_array
     sort.collect(&:last)
   end
end