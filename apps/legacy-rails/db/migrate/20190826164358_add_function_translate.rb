class AddFunctionTranslate < ActiveRecord::Migration
  def change
    reversible do |dir|
      dir.up do
        connection.execute(%q(
          CREATE OR REPLACE FUNCTION sp_ascii(character varying)
          RETURNS text AS
          $BODY$
          SELECT TRANSLATE
          ($1,
          'áàâãäéèêëíìïóòôõöúùûüÁÀÂÃÄÉÈÊËÍÌÏÓÒÔÕÖÚÙÛÜçÇ',
          'aaaaaeeeeiiiooooouuuuAAAAAEEEEIIIOOOOOUUUUcC');
          $BODY$
          LANGUAGE 'sql' IMMUTABLE;
        ))
      end
      dir.down do
        connection.execute(%q(
          drop function sp_ascii
        ))
      end
    end
    
  end
end

