CREATE NEW ASSOCIATION WITH CLACOMS

silly = Sodimac::Clacom.where(name: "123 - NO TIENE CLACOM", code: "dummycode").last
t = 0
createds = []
ID_GS1.each do |cat_code|
  t += 1
  next if cat_code == "nil"
  gs_1 = Sodimac::Category.where(code: cat_code).last
  next if gs_1.nil?
  geted_clacom = Sodimac::Clacom.where(code: clacom[t - 1].rjust(10, '0') ).last
  geted_clacom.nil? ? clacom_id = silly.id : clacom_id = geted_clacom.id
  cat_clacom = Sodimac::CategoryClacom.where(category_id: gs_1.id, sodimac_clacom_id: clacom_id ).last
  if cat_clacom.nil?
    cl = Sodimac::CategoryClacom.create( category_id: gs_1.id, sodimac_clacom_id: clacom_id   )
    createds << cl.id
  end
end


DESTROY ALL ASSOCIATIONS

s = Sodimac::CategoryClacom.where('created_at BETWEEN ? AND ?', Time.now - 4.years, Time.now )
destruidas = []
s.each do |destroyed|
  destruidas << destroyed.id
  destroyed.really_destroy!
end
