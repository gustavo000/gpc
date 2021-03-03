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
docker run -it --entrypoint /bin/bash --env-file ./products_api_env_latest -v "$PWD":/tmp --name 'gpc_migration' svldevelopment.azurecr.io/falabella-svl/api-products:4777c249

MIGRATION_FILE = Rails.root.join('gpc/product-attributes-update19.csv')
REPORT_CSV = []

GPC_IDS = []
ATT_IDS = []
DISPLAY_NAMES = []
MEASURE_UNITS = []
DESCRIPTIONS = []
REQUIRED = []
EXAMPLES = []
UNITS = []
TYPES = []

# Know File Headers, looks like %(Name	Level	ID_GPC	ID_PIM)
CSV.read(MIGRATION_FILE, headers: true, col_sep: ';', quote_char: "\x00").headers

CSV.foreach(MIGRATION_FILE, headers: :first_row, col_sep: ';', quote_char: "\x00") do |row|
  GPC_IDS << row['GPC']
  ATT_IDS << row['AttributeID']
  DISPLAY_NAMES << row['Atributo']
  DESCRIPTIONS << row['Descripcion']
  REQUIRED << row['Requerido']
  EXAMPLES << row['Ejemplo']
  MEASURE_UNITS << row['UnidadMedida']
  TYPES << row['Tipo']
end

def get_next_index(current_index, gpc_ids, max_index)
  word = gpc_ids[current_index]
  more = true

  while (more && current_index < max_index)
    if word != gpc_ids[current_index]
      more = false
    else
      current_index += 1
    end
  end

  current_index
end

current_index = 0
max_index = 999 #GPC_IDS.size

ActiveRecord::Base.transaction do
  sleep(120) if current_index.next % 1001 == 0

  while(current_index < max_index)
    end_index = get_next_index(current_index, GPC_IDS, max_index)

    current_gpc_id = GPC_IDS[current_index]&.strip
    current_att_id = ATT_IDS[current_index]&.strip

    category = Sodimac::Category.find_by(code: current_gpc_id)

    unless category
      REPORT_CSV << [current_gpc_id, current_att_id, DISPLAY_NAMES[current_index]&.strip, 'category_not_found', '']
      puts "Category not found #{ current_gpc_id }"
      current_index += 1
      next
    end

    current_display_name = DISPLAY_NAMES[current_index]&.strip
    current_description = DESCRIPTIONS[current_index]&.strip
    current_required = REQUIRED[current_index]&.strip&.to_boolean
    current_example = EXAMPLES[current_index]&.strip
    current_measure_unit = MEASURE_UNITS[current_index]&.strip
    current_type = TYPES[current_index]&.strip

    current_attributes = category.product_attributes.select!{|items| items['name'] == current_att_id}

    REPORT_CSV << [current_gpc_id, current_att_id, current_display_name, 'category_product_attributes_previous', current_attributes]

    while(current_index < end_index)
      category_product_attributes = category.product_attributes

      category.product_attributes.each do |attr|
        old_display_name = attr['display_name']&.strip
        old_description = attr['description']&.strip
        old_required = attr['required']&.to_boolean
        old_example = attr['example']&.strip
        old_measure_unit = attr['measure_unit']&.strip
        old_type = attr['data_type']&.strip

        changed = false
        changes = []
        ## if attribute exist then update
        if attr['name'] == current_att_id
          if (old_display_name != current_display_name)
            changed = true
            changes << { before: old_display_name, after: current_display_name }
          end
          if (old_description != current_description)
            changed = true
            changes << { before: old_description, after: current_description }
          end
          if (old_required != current_required)
            changed = true
            changes << { before: old_required, after: current_required }
          end
          if (old_example != current_example)
            changed = true
            changes << { before: old_example, after: current_example }
          end
          if (old_measure_unit != current_measure_unit)
            changed = true
            changes << { before: old_measure_unit, after: current_measure_unit }
          end
          if (old_type != current_type)
            changed = true
            changes << { before: old_type, after: current_type }
          end

          puts "ATTRS CHANGED? #{changed}"

          if changed
            puts "Category Product Attributes Changed #{ current_gpc_id }"

            attr['display_name'] = current_display_name if current_display_name.present?
            attr['description'] = current_description if current_description.present?
            attr['required'] = current_required if current_required.present?
            attr['example'] = current_example if current_example.present?
            attr['measure_unit'] = current_measure_unit if current_measure_unit.present?
            attr['data_type'] = current_type if current_type.present?

            if category.product_attributes_will_change! # && category.save
              REPORT_CSV << [current_gpc_id, current_att_id, current_display_name, 'category_product_attributes_changed', changes]
            else
              REPORT_CSV << [current_gpc_id, current_att_id, current_display_name, 'category_product_attributes_not_changed', changes]
            end
          end
        else  ## else attribute is new
          new_attribute = {}
          existing_product_attributes = category.product_attributes.map{|x|x}

          new_attribute['name'] = current_att_id if current_att_id.present?
          new_attribute['display_name'] = current_display_name if current_display_name.present?
          new_attribute['description'] = current_description if current_description.present?
          new_attribute['required'] = current_required if current_required.present?
          new_attribute['example'] = current_example if current_example.present?
          new_attribute['measure_unit'] = current_measure_unit if current_measure_unit.present?
          new_attribute['data_type'] = current_type if current_type.present?
          new_attribute['define_stock'] = false

          existing_product_attributes << new_attribute
          category.product_attributes = category_product_attributes

          # if category.save
            puts "New Product Attribute Added #{ new_attribute }"
            REPORT_CSV << [current_gpc_id, current_att_id, current_display_name, 'new_category_product_attribute', new_attribute]
          # else
          #   puts "Product Attribute Not Added #{ new_attribute }"
          #   REPORT_CSV << [current_gpc_id, current_att_id, current_display_name, 'not_updated_category_product_attribute', category.errors.details.to_s]
          # end
        end
      end
      current_index += 1
    end
  end

  file = 'product-attributes-update-result.csv'

  CSV.open( file, 'w', encoding: 'UTF-8', quote_char: "\x00", col_sep: ';') do |writer|
    writer << ['GPC', 'ATTRIBUTE ID', 'ATTRIBUTE', 'STATUS', 'DETAILS']
    REPORT_CSV.each{|item| writer << item }
  end
end