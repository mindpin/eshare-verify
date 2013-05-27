class CreateVerifyCodes < ActiveRecord::Migration
  def change
    create_table :verify_codes do |t|
      t.string :code # key 和 mac 计算得来
      t.string :ip
      t.text   :desc
      t.timestamps
    end
  end
end
