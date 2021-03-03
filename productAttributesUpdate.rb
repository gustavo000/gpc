# Se carga el output de la juguera, que considera:

# 1. Atributos obligatorios por cada brick
# 2. Atributos opcionales por cada brick
# 3. Formato del atributo (Numerico, Texto, Lista de Valor)
# 4. Listas de valor que hay que cargar
# 5. Tootlip: cada atributo tiene un tootlip para apoyar al seller a crearlo (esto lo hace el BA MKP con apoyo de OPS MKP)
# 6. Place holder: en cada campo el place holder debería ser el ejemplo de cómo completar el atributo.

# NO olvidar:

# 1. Hay que dejar el atributo garantía como opcional
# 2. Hay que sacar el atributo "dimensiones"
# 3. Los campos asociados a solicitudes de subida de certificados dejarlos como opcionales (en esta versión no actualizaron certificados por ende se debe asegurar que los que ya se piden sean "optativos")
sudo docker rm $(docker ps -a -q) -f
docker run -it --entrypoint /bin/bash --env-file ./products_api_env_latest -v "$PWD":/tmp --name 'gpc_migration' svldevelopment.azurecr.io/falabella-svl/api-products:4777c249
apk add git
git clone https://gitlab.com/gustavo-corp/gpc.git


MIGRATION_FILE = Rails.root.join('gpc/product-attributes-update.csv')
REPORT_CSV = []
​
GPC_IDS = []
ATT_IDS = []
DISPLAY_NAMES = []
MEASURE_UNITS = []
DESCRIPTIONS = []
REQUIRED = []
EXAMPLES = []
UNITS = []
TYPES = []
​
# Know File Headers, looks like %(Name	Level	ID_GPC	ID_PIM)
CSV.read(MIGRATION_FILE, headers: true, col_sep: ';', quote_char: "\x00").headers
​
CSV.foreach(MIGRATION_FILE, headers: :first_row, col_sep: ';', quote_char: "\x00") do |row|
  GPC_IDS << row['GPC']
  ATT_IDS << row['AttributeID']
  DISPLAY_NAMES << row['Atributo']
  DESCRIPTIONS << row['Descripcion']
  REQUIRED << row['Requerido']
  EXAMPLES << row['Ejemplo']
  MEASURE_UNITS << row['UnidadMedida']
  TYPES << row['Tipo']2
end
​
def get_next_index(current_index, gpc_ids, max_index)
  word = gpc_ids[current_index]
  more = true
​
  while (more && current_index < max_index)
    if word != gpc_ids[current_index]
      more = false
    else
      current_index += 1
    end
  end
​
  current_index
end
​
ActiveRecord::Base.transaction do
  current_index = 3108
  max_index = 3010#GPC_IDS.size
​
#  while(current_index < max_index)
#    sleep(15) if current_index.next % 1000 == 0
    #end_index = get_next_index(current_index, GPC_IDS, max_index)
    #category = Sodimac::Category.where(code: GPC_IDS[current_index]).last
​
    #if category
    #  # If detect some attributes duplicated, uncomment this lines to remove it
​#
    #  # uniqueness_attributes = []
    #  # category.product_attributes.each do |attribute|
    #  #   uniqueness_attributes << attribute unless uniqueness_attributes.map{|attr| attr['name']}.include? attribute['name']
    #  # end
​#
    #  # category.update(product_attributes: uniqueness_attributes)
​#
    #  while(current_index < end_index)
    #    current_gpc_id = GPC_IDS[current_index]&.strip
    #    current_att_id = ATT_IDS[current_index]&.strip
    #    current_display_name = DISPLAY_NAMES[current_index]&.strip
    #    current_description = DESCRIPTIONS[current_index]&.strip
    #    current_required = REQUIRED[current_index]&.strip&.to_boolean
    #    current_example = EXAMPLES[current_index]&.strip
    #    current_measure_unit = MEASURE_UNITS[current_index]&.strip
    #    current_type = TYPES[current_index]&.strip
​#
    #    attribute_geted = false
    #    category.product_attributes.each do |attr|
    #      old_display_name = attr['display_name']&.strip
    #      old_description = attr['description']&.strip
    #      old_required = attr['required']&.to_boolean
    #      old_example = attr['example']&.strip
    #      old_measure_unit = attr['measure_unit']&.strip
    #      old_type = attr['data_type']&.strip
​#
    #      changed = false
    #      changes = []
​#
    #      #puts "=============== NAME: #{attr['name']} / #{current_att_id} / CATEGORY_ID: #{category.id} ==============="
​#
    #      if attr['name'] == current_att_id
    #        if (old_display_name != current_display_name)
    #          changed = true
    #          changes << { display_name: { before: old_display_name, after: current_display_name }}
    #        end
    #        if (old_description != current_description)
    #          changed = true
    #          changes << { description: { before: old_description, after: current_description }}
    #        end
    #        if (old_required != current_required)
    #          changed = true
    #          changes << { required: { before: old_required, after: current_required }}
    #        end
    #        if (old_example != current_example)
    #          changed = true
    #          changes << { example: { before: old_example, after: current_example }}
    #        end
    #        if (old_measure_unit != current_measure_unit)
    #          changed = true
    #          changes << { measure_unit: { before: old_measure_unit, after: current_measure_unit }}
    #        end
    #        if (old_type != current_type)
    #          changed = true
    #          changes << { data_type: { before: old_type, after: current_type }}
    #        end
​#
    #        attr['display_name'] = current_display_name if current_display_name.present?
    #        attr['description'] = current_description if current_description.present?
    #        attr['required'] = current_required if current_required.present?
    #        attr['example'] = current_example if current_example.present?
    #        attr['measure_unit'] = current_measure_unit if current_measure_unit.present?
    #        attr['data_type'] = current_type if current_type.present?
​#
    #        attribute_geted = true
    #        category.product_attributes_will_change!
​#
    #        if changed && category.save
    #          REPORT_CSV << [current_gpc_id, current_att_id, current_display_name, 'category_product_attributes_changed', changes]
    #        else
    #          REPORT_CSV << [current_gpc_id, current_att_id, current_display_name, 'category_product_attributes_not_changed', changes]
    #        end
    #      end
​#
    #      unless attribute_geted
    #        new_attribute = {}
    #        existing_attributes = category.product_attributes.map{|x| x}
​#
    #        new_attribute['name'] = current_att_id if current_att_id.present?
    #        new_attribute['display_name'] = current_display_name if current_display_name.present?
    #        new_attribute['description'] = current_description if current_description.present?
    #        new_attribute['required'] = current_required if current_required.present?
    #        new_attribute['example'] = current_example if current_example.present?
    #        new_attribute['measure_unit'] = current_measure_unit if current_measure_unit.present?
    #        new_attribute['data_type'] = current_type if current_type.present?
    #        new_attribute['define_stock'] = false
​#
    #        existing_attributes << new_attribute
    #        category.product_attributes = existing_attributes
#
    #        if category.save!
    #          REPORT_CSV << [current_gpc_id, current_att_id, current_display_name, 'new_category_product_attribute', new_attribute]
    #        else
    #          REPORT_CSV << [current_gpc_id, current_att_id, current_display_name, 'not_updated_category_product_attribute', category.errors.details.to_s]
    #        end
    #      end
​#
    #      category.save if category.changed?
    #      current_index += 1
    #    end
    #  end
    #  current_index = end_index
  end
​
  #file = 'product-attributes-update-result.csv'
​#
  #CSV.open( file, 'w', encoding: 'UTF-8', quote_char: "\x00", col_sep: ';') do |writer|
  #  writer << ['GPC', 'ATTRIBUTE ID', 'ATTRIBUTE',  'STATUS', 'DETAILS']
  #  REPORT_CSV.each{|item| writer << item }
  #end
end
