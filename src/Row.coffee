
{Element} = require "react-validators"

emptyFunction = require "emptyFunction"
ReactType = require "modx/lib/Type"
View = require "modx/lib/View"

ScrollChild = require "./Child"

type = ReactType "Scrollable_Row"

type.inherits ScrollChild

type.defineOptions
  key: String
  props: Object
  render: Function.Kind
  element: Element

type.defineValues (options) ->

  key: options.key

  _props: options.props

  _render: options.render

  _element: options.element

type.defineValues

  __renderContents: ->
    if @_element then -> @_element
    else if @_render then -> @_render @_props

#
# Prototype-related
#

type.defineBoundMethods

  _rootDidLayout: (event) ->
    {layout} = event.nativeEvent

    newLength = layout[if @scroll.isHorizontal then "width" else "height"]
    return if newLength is oldLength = @_length

    @_setLength newLength
    @_section.__childDidLayout this, newLength - oldLength
    @_didLayout.emit()
    return

#
# Rendering
#

type.render ->
  return View
    ref: @_rootDidRef
    style: [
      @styles.container()
      @_rootStyle
    ]
    children: @__renderContents()
    onLayout: @_rootDidLayout

type.willMount ->
  @props.row = this

type.willReceiveProps (props) ->
  props.row = this

type.defineHooks

  __renderContents: emptyFunction.thatReturnsFalse

type.defineStyles

  container:
    overflow: "hidden"

module.exports = type.build()
