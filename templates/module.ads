{% extends "base.ads" -%}
{% block package_spec -%}
--  {{ module.path }}

with HAL; use HAL;
with System;

pragma Warnings (Off, "bits of *unused*");
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
   end record
      with Volatile, Size => {{ register.size }};

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

   {% if register.instances > 1 %}
   type {{ register.id }}_Register_Array is array (0 .. {{ register.instances - 1 }}) of {{ register.id }}_Register
      with Component_Size => {{ register.size }};
   {% endif %}

   {% endfor %}

   type {{ module.id }}_Peripheral is record
      {% for register in module.registers -%}
      {{ register.id|rename }} : aliased {{ register.id }}_Register{% if register.instances > 1 %}_Array{% endif %};
      {% endfor %}
   end record
      with Size => {{ module.size }};

   for {{ module.id }}_Peripheral use record
      {% for register in module.registers -%}
      {{ register.id|rename }} at {{ register.offset|hexformat }} range 0 .. {{ (register.size * register.instances) - 1 }};
      {% endfor %}
   end record;

   {% for instance in module.instances -%}
   {{ module.id }}{% if module.instances|length > 1 %}{{ loop.index0 }}{% endif %}_Periph : aliased {{ module.id }}_Peripheral
      with Import, Address => System'To_Address ({{ instance.baseaddr|hexformat }});
   {% endfor %}

end {{ device.id }}.{{ module.id }};
{% endblock %}
