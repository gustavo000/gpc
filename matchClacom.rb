prd images
  supp
  docker rm $(sudo docker ps -aqf "name=gpc_migration")
  docker run -it --entrypoint /bin/bash --env-file ./products_api_env -v "$PWD":/tmp --name 'gpc_migration' svldevelopment.azurecr.io/falabella-svl/api-products:4777c249
test
  supp
  sudo docker rm $(docker ps -a -q) -f
  docker rm $(sudo docker ps -aqf "name=gpc_migration")
  docker run -it --entrypoint /bin/bash --env-file ./products_api_env_latest -v "$PWD":/tmp --name 'gpc_migration' svldevelopment.azurecr.io/falabella-svl/api-products:4777c249

apk add git
git clone https://gitlab.com/killng/dwqdwqd.git
mv dwqdwqd/ gpc
rails c

MIGRATION_FILE = Rails.root.join('gpc/match-clacom19.csv')
DUMMY_CLACOM = Sodimac::Clacom.find_by(name: '123 - NO TIENE CLACOM', code: 'dummycode')
REPORT_CSV = []
i = 0
ActiveRecord::Base.transaction do
  CSV.foreach(MIGRATION_FILE, headers: :first_row, col_sep: ',', quote_char: "\x00") do |row|
    #if i.next % 500 == 0
    #  puts "
    #
    #
    #   CURRENT UPDATE
    #    #{current_index}  #{}   #{}
    #
    #
    #    "
    #  sleep(2)
    #end
    category_code = row['ID GS1']
    clacom_code = row['Clacom']&.rjust(10, '0')
    name = row['Nombre clacom']

    puts "Init migration for Category Code: #{ category_code } - CLACOM: #{ name } ID: #{ clacom_code }"

    unless category_code.present?
      puts "ID GS1 is empty for CLACOM: #{ name } - ID: #{ clacom_code }"

      REPORT_CSV << [category_code, clacom_code, name, 'fail', 'ID GS1 is empty']
      next
    end

    category = Sodimac::Category.find_by(code: category_code)

    unless category
      puts "CATEGORY not found for CLACOM: #{ name } - ID: #{ clacom_code }"

      REPORT_CSV << [category_code, clacom_code, name, 'fail', 'CATEGORY not found']
      next
    end

    clacom = Sodimac::Clacom.find_by(code: clacom_code)

    if clacom
      clacom.name = name
      if clacom.save
        REPORT_CSV << [category_code, clacom_code, name, 'clacom_name_updated', clacom.previous_changes]
      end
    else
      clacom = Sodimac::Clacom.create(code: clacom_code.rjust(10, '0'), name: name)
    end
    category_clacom = Sodimac::CategoryClacom.find_by(
      category_id: category.id,
      sodimac_clacom_id: clacom.id
    )
    unless category_clacom
      clacom  && clacom&.id ? '' : clacom = DUMMY_CLACOM
      new_category_clacom = Sodimac::CategoryClacom.create(
        category_id: category.id,
        sodimac_clacom_id: clacom.id
      )
      puts "CATEGORY CLACOM created for CATEGORY_ID: #{ new_category_clacom.id } - CLACOM_ID: #{ clacom.id }"

      REPORT_CSV << [category_code, clacom.id, name, 'category_clacom_created', new_category_clacom.to_json]
    else
      REPORT_CSV << [category_code, clacom_code, name, 'category_clacom_exist', category_clacom.to_json]
    end
    i += 1
  end

  file = 'match-clacom-result.csv'

  CSV.open( file, 'w' ) do |writer|
    writer << ['CATEGORY CODE', 'CLACOM', 'NAME', 'STATUS', 'DETAILS']
    REPORT_CSV.each{|item| writer << item }
  end
end
exit
mv match-clacom-result.csv.csv /tmp/match-clacom-result.csv
exit
scp svlsupport@52.177.16.236:/home/svlsupport/match-clacom-result.csv ~/Desktop/


# s = Sodimac::CategoryClacom.where('created_at BETWEEN ? AND ?', Time.now - 4.years, Time.now )
# destruidas = []
# s.each do |destroyed|
#   destruidas << destroyed.id
#   destroyed.really_destroy!
# end
