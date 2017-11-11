{{--CASE--}}:
    var {{--PARAM_ARR--}} = [];
    {{--PARAM_PARSERS--}}
    var process = child_process.execFile('./{{--SCRIPT_NAME--}}' , {{--PARAM_ARR--}})
    process.stdout.pipe(response.connection)
    process.stderr.pipe(response.connection)
    break
