module TemplatesHelper
    def private_or_public(template)
        if template.private == true
            "Yes".html_safe
        else
            "No".html_safe
        end
    end
end
