{% from 'macros.tpl' import planetlink with context %}
{% macro exiletable(exiles) %}
<table cellspacing="1" cellpadding="3" width="95%" class="black">
    <tr class="header">
        <th>Rank</th>
        <th>Old</th>
        <th>New</th>
        <th>Current</th>
        <th colspan="8">{{caller()}}</th>
        <th colspan="3"><a href="" onclick="toggleGrowth();return false;">Growth</a></th>
        <th></th>
    </tr>
    <tr class="header">
        <th>Score</th>
        
        <th align="right">X:Y &nbsp;Z</th>
        <th align="right">X:Y &nbsp;Z</th>
        <th align="right">X:Y &nbsp;Z</th>
        
        <th>Ruler</th>
        <th>Planet</th>
        <th>Race</th>
        <th>Size</th>
        <th>Value</th>
        <th>Score</th>
        <th>Ratio</th>
        <th>XP</th>
        
        <th>Size</th>
        <th>Value</th>
        <th>Score</th>
        
        <th>Tick</th>
    </tr>
    {% for exile in exiles %}
    {% set planet = exile.history %}
    {% set current = exile.planet %}
    <tr class="{%if not exile.old %}new{%elif not exile.new %}deleted{%else%}{{loop.cycle('odd', 'even')}}{%endif%}{%if not current.active%} nolongerexists{%endif%}">
        <td align="right">{%if planet.active %}{{ planet|rank("score") }}{%endif%}</td>
        
        <td align="right">
        {%if exile.old %}
            <a href="{% url "galaxy", exile.oldx, exile.oldy %}">{{ exile.oldx }}:{{ exile.oldy }}</a>
            &nbsp;{{ exile.oldz }}
        {%else%}<span class="new">New</span>{%endif%}
        </td>
        <td align="right">
        {%if exile.new %}
            <a href="{% url "galaxy", exile.newx, exile.newy %}">{{ exile.newx }}:{{ exile.newy }}</a>
            {%if current.active and current.galaxy == planet.galaxy and current.z == planet.z %}
            <a href="{% url "planet", exile.newx, exile.newy, exile.newz %}">&nbsp;{{ exile.newz }}</a>
            {%else%}
            &nbsp;{{ exile.newz }}
            {%endif%}
        {%else%}<span class="deleted">Deleted</span>{%endif%}
        </td>
        <td align="right">
        {%if exile.new and current.active and (current.galaxy != planet.galaxy or current.z != planet.z)%}
            <a href="{% url "galaxy", planet.x, planet.y %}">{{ planet.x }}:{{ planet.y }}</a>
            <a href="{% url "planet", planet.x, planet.y, planet.z %}">&nbsp;{{ planet.z }}</a>
        {%endif%}
        </td>
        
        <td>{{ planet.rulername }}</td>
        <td>{{ planet.planetname }}</td>
        <td class="{{ planet.race }}">{{ planet.race }}</td>
        {%if not planet.active %}
        <td align="center" colspan="8"><i>Planet doesn't exist anymore.</i></td>
        {%else%}
        <td align="right">{{ planet|bashcap("size") }}</td>
        <td align="right">{{ planet|bashcap("value") }}</td>
        <td align="right">{{ planet|bashcap("score") }}</td>
        <td align="right">{{ planet.ratio|round(1) }}</td>
        <td align="right">{{ planet.xp|intcomma }}</td>
        
        <td align="right">{{ planet|growth("size") }}</td>
        <td align="right">{{ planet|growth("value") }}</td>
        <td align="right">{{ planet|growth("score") }}</td>
        {%endif%}
        
        <td align="right">{{exile.tick}}</td>
    </tr>
    {% endfor %}

</table>
{% endmacro %}
{% extends "base.tpl" %}
{% block content %}
{% call exiletable(exiles) %}
    {% if through is not defined %}
    Recent
    {% elif through %}
    {% elif not through -%}
        {% if galaxy is defined %}      <a href="{% url "galaxy", galaxy.x, galaxy.y %}">{{ galaxy.x }}:{{ galaxy.y }}</a>
        {% elif planet is defined %}    <a href="{% url "galaxy", planet.x, planet.y %}">{{ planet.x }}:{{ planet.y }}</a>
                                            <a {{planetlink(planet)}}>{{ planet.z }}</a>
        {%- endif %}'s
    {% endif %}
    Planet Movements
    {% if through is not defined %}
    {% elif through %} Through
        {% if galaxy is defined %}      <a href="{% url "galaxy", galaxy.x, galaxy.y %}">{{ galaxy.x }}:{{ galaxy.y }}</a>
        {% elif planet is defined %}    <a href="{% url "galaxy", planet.x, planet.y %}">{{ planet.x }}:{{ planet.y }}</a>
                                            <a {{planetlink(planet)}}>{{ planet.z }}</a>
        {% endif %}
    {% elif not through -%}
    {% endif %}
{% endcall %}
{% endblock %}
