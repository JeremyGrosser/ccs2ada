{% extends "base.ads" -%}
{% block package_spec -%}
--  {{ device.path }}

package {{ device.id }} is
   pragma Pure;
end {{ device.id }};
{% endblock %}
