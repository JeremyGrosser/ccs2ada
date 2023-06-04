{% extends "base.ads" -%}
{% block package_spec -%}
--  {{ module.path }}

with HAL; use HAL;
with System;

package {{ device.id }}.{{ module.id }} is
   pragma Preelaborate;

   {% for register in module.registers -%}
   {% if register.bitfields -%}
   {% for bitfield in register.bitfields -%}
   subtype {{ register.id }}_{{ bitfield.id }}_Field is {% if bitfield.size == 1 %}Bit{% else %}UInt{{ bitfield.size }}{% endif %};
   {% endfor %}
   type {{ register.id }}_Register is record
      {% for bitfield in register.bitfields -%}
      {{ bitfield.id|rename }} : {{ register.id }}_{{ bitfield.id }}_Field := {{ bitfield.resetval }};
      --  {{ bitfield.description }}
      {% endfor %}
   end record;

   for {{ register.id }}_Register use record
      {% for bitfield in register.bitfields -%}
      {{ bitfield.id|rename }} at 0 range {{ bitfield.first }} .. {{ bitfield.last }};
      {% endfor %}
   end record;
   {% else -%}
   subtype {{ register.id }}_Register is UInt{{ register.size }};
   {% if register.description -%}
   --  {{ register.description }}
   {% endif %}{% endif %}
   {% endfor %}

   type {{ module.id }}_Peripheral is record
      {% for register in module.registers -%}
      {{ register.id|rename }} : aliased {{ register.id }}_Register;
      {% endfor %}
   end record;

   for {{ module.id }}_Peripheral use record
      {% for register in module.registers -%}
      {{ register.id|rename }} at {{ register.offset }} range 0 .. {{ register.size-1 }};
      {% endfor %}
   end record;

   {% for instance in module.instances -%}
   {{ module.id }}{% if module.instances|length > 1 %}{{ loop.index0 }}{% endif %}_Periph : aliased {{ module.id }}_Peripheral
      with Import, Address => System'To_Address ({{ instance.baseaddr }});
   {% endfor %}

end {{ device.id }}.{{ module.id }};
{% endblock %}
