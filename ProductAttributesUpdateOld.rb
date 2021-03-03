GET REPEATER
daert = []
Sodimac::Category.all[0..5000].each do |c|
  names = c.product_attributes.map{ |x| x['name']}
  if names.detect{ |e| names.count(e) > 1 }
    daert << c.id
  end
end
daert




names = Sodimac::Category.where.not( product_attributes: '[]').last.product_attributes.map{|x| x['name']}
cat = nil
Sodimac::Category.all.each do |x|
  if x.product_attributes.size > 0
    cat = x
    break
  end
end
cat

ids = [24991, 25074, 25092, 25093, 25096, 25097, 25098, 25099, 25100, 25101, 25102, 25103, 25104, 25106, 25107, 25109, 25111, 25112, 25153, 25227, 25228, 25229, 25230, 25231, 25232, 25233, 25234, 25235, 25236, 25237, 25238, 25240, 25241, 25242, 25243, 25245, 25246, 25247, 25248, 25249, 25250, 25251, 25252, 25254, 25255, 25256, 25257, 25258, 25259, 25260, 25261, 25262, 25263, 25264, 25265, 25266, 25267, 25268, 25270, 25271, 25272, 25273, 25275, 25276, 25277, 25278, 25279, 25281, 25282, 25283, 25284, 25286, 25287, 25288, 25289, 25291, 25292, 25293, 25294, 25295, 25296, 25298, 25299, 25300, 25301, 25303, 25304, 25305, 25306, 25307, 25309, 25310, 25311, 25312, 25313, 25314, 26115, 31468]
ids.each do |x|
  cat = Sodimac::Category.find(x)
  names = cat.product_attributes.map{|p| p['name']}
  repeated_value = names.detect{ |e| names.count(e) > 1 }
  while repeated_value != nil
    index_repeated = names.index(repeated_value)
    cat.product_attributes.delete_at(index_repeated)
    cat.save
    names = cat.product_attributes.map{|s| s['name']}
    repeated_value = names.detect{ |e| names.count(e) > 1 }
    puts "


      ID
      #{x}  REPEATED VALUE #{repeated_value}  #{}   #{}


      "
  end
end


ids = [24991, 25074, 25092, 25093, 25096, 25097, 25098, 25099, 25100, 25101, 25102, 25103, 25104, 25106, 25107, 25109, 25111, 25112, 25153, 25227, 25228, 25229, 25230, 25231, 25232, 25233, 25234, 25235, 25236, 25237, 25238, 25240, 25241, 25242, 25243, 25245, 25246, 25247, 25248, 25249, 25250, 25251, 25252, 25254, 25255, 25256, 25257, 25258, 25259, 25260, 25261, 25262, 25263, 25264, 25265, 25266, 25267, 25268, 25270, 25271, 25272, 25273, 25275, 25276, 25277, 25278, 25279, 25281, 25282, 25283, 25284, 25286, 25287, 25288, 25289, 25291, 25292, 25293, 25294, 25295, 25296, 25298, 25299, 25300, 25301, 25303, 25304, 25305, 25306, 25307, 25309, 25310, 25311, 25312, 25313, 25314, 26115, 31468]
ids.each do |x|
  cat = Sodimac::Category.find(x)
  names = cat.product_attributes.map{|p| p['name']}
  repeated_value = names.detect{ |e| names.count(e) > 1 }
  while repeated_value != nil
    index_repeated = names.index(repeated_value)
    cat.product_attributes.delete_at(index_repeated)
    cat.save
    names = cat.product_attributes.map{|s| s['name']}
    repeated_value = names.detect{ |e| names.count(e) > 1 }
    puts "


      ID
      #{x}  REPEATED VALUE #{repeated_value}  #{}   #{}


      "
  end
  sleep
end

ids = [24991, 25074, 25092, 25093, 25096, 25097, 25098, 25099, 25100, 25101, 25102, 25103, 25104, 25106, 25107, 25109, 25111, 25112, 25153, 25227, 25228, 25229, 25230, 25231, 25232, 25233, 25234, 25235, 25236, 25237, 25238, 25240, 25241, 25242, 25243, 25245, 25246, 25247, 25248, 25249, 25250, 25251, 25252, 25254, 25255, 25256, 25257, 25258, 25259, 25260, 25261, 25262, 25263, 25264, 25265, 25266, 25267, 25268, 25270, 25271, 25272, 25273, 25275, 25276, 25277, 25278, 25279, 25281, 25282, 25283, 25284, 25286, 25287, 25288, 25289, 25291, 25292, 25293, 25294, 25295, 25296, 25298, 25299, 25300, 25301, 25303, 25304, 25305, 25306, 25307, 25309, 25310, 25311, 25312, 25313, 25314, 26115, 31468]
ids.each do |x|
  cat = Sodimac::Category.find(x)
  _attributes = cat.product_attributes
  uniqueness_attributes = []
  _attributes.each do |attribute|
    uniqueness_attributes << attribute unless uniqueness_attributes.map{|attr| attr['name']}.include? attribute['name']
  end
  cat.product_attributes = uniqueness_attributes
  cat.save
end

  uniqueness_attributes


names = cat.product_attributes.map{|x| x['name']}
Sodimac::Category.find(26218).product_attributes

names = Sodimac::Category.find_by(code: '10003009').product_attributes.map{|x| x['name']}


names.detect{ |e| names.count(e) > 1 }

["A2179233", "A2179233", "A2172257", "CL-A99900122", "CL-A99900143", "CL-A99900333", "A2171159", "CL-A99900427", "CL-A99900598", "CL-A88800177", "CL-A99900252", "A1662697", "CL-A99900271", "CL-A99000144", "CL-A99000142", "CL-A99000143", "CL-A99000145", "CL-A99900427", "CL-A99900598", "CL-A88800177", "CL-A99900252", "A1662697", "CL-A99000144", "CL-A99000142", "CL-A99000143", "CL-A99000145", "CL-A99900427", "CL-A99900598", "CL-A88800177", "CL-A99900252", "A1662697", "CL-A99000144", "CL-A99000142", "CL-A99000143", "CL-A99000145"]