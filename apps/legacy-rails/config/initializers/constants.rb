DISTANCE_UNITS = (Rails.application.secrets.distance_units || :km).to_sym

MAX_DISTANCE_FROM_BUILDING = (Rails.application.secrets.max_distance_from_building || 10).to_i

CUSTOMER_SUPPORT = Rails.application.secrets.customer_support || '438 998 5221, weekdays 10am - 6pm EST'

CM_SUPPORT_MAIL = Rails.application.secrets.cm_support_mail || 'support@condo-media.com'

CM_INFO_MAIL = 'info@condo-media.com'

CM_SALES_MAIL = 'sales@condo-media.com'

REFUND_POLICY_URL = 'http://www.tuango.ca/en/pages/politique-de-remboursement'

CM_LOCALES = %w[en fr es]

SEXES = %w[m f]

RELATIONSHIPS = %w[single married]
