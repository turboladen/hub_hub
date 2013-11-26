# for more details see: http://emberjs.com/guides/views/

HubHub.MenuItemView = Ember.View.extend
  templateName: 'components/menu_item'
  tagName: 'a'
  classNames: ["btn"]
  attributeBindings: ['href', 'hidden']
  hidden: "hidden"
