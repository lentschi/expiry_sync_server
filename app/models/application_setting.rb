class ApplicationSetting < ActiveRecord::Base
    def self.set_redirect_url(url)
        redirect_setting = ApplicationSetting.find_by_setting_key('redirect_url')
        originalValue = nil

        unless redirect_setting
            redirect_setting = ApplicationSetting.new
            redirect_setting.setting_key = 'redirect_url'
        else
            originalValue = redirect_setting.setting_value
        end
        redirect_setting.setting_value = url
        redirect_setting.save

        Rails.logger.info originalValue.nil? ? "Setting created" : "Setting updated from '#{originalValue}'"
    end

    def self.remove_redirect_url!()
        redirect_setting = ApplicationSetting.find_by_setting_key('redirect_url')
        if redirect_setting
            redirect_setting.delete
        else
            Rails.logger.info "Setting not found"
        end
    end
end