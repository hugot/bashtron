for (name in {{--GET_PARAMS--}}) {
  {{--PARAM_ARR--}}.push('-g')
  {{--PARAM_ARR--}}.push(name)
  {{--PARAM_ARR--}}.push({{--GET_PARAMS--}}[name])
}
