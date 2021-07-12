
function parse_weight(x)
    weight_sign = match(r"\+|\-", x)
    if isnothing(weight_sign)
        weight_sign = "+"
    else
        weight_sign = weight_sign.match
    end
    parse(Float64, string(weight_sign, match(r"\d+\.\d+", x).match))
end

function read_weight(sp,bytes = 31)
    weight = String(read(sp, bytes))

    if length(weight) == 0
        weight = read_weight(sp, bytes)
    end

    if last(weight) != '\n'
        if last(weight) == 'N'
            # The data sent is not stable, so there is no unit (e.g. 30 bytes only instead of 31)
            # We have to get back to the normal so we read e.g. 30 bytes and then 31
            # to make up for the delay:
            read_weight(sp, bytes - 1);
            weight = read_weight(sp)
        else
            weight = read_weight(sp, bytes)
        end
    end

    return weight
end

function measure_weight(file_path,portname,baudrate,bits,stopbits)
    # Initialise a weight measurement:
    weight_value = Any[missing]

    # Initialise the last date of measurement:
    date_before = [now()]

    # integration_step = integration_step * 1000 # transform into microsecond
    println("Connecting to port $portname")
    sp = SerialPort(portname, baudrate,bits,stopbits)
    # sp = open(portname, baudrate)
    # print_port_metadata(sp)
    # print_port_settings(sp)
    try
        while true
            try
                if bytesavailable(sp) > 0
                    # LibSerialPort.sp_output_waiting #  number of bytes in the output buffer
                    # LibSerialPort.read

                    # Read the values and put into the buffer until we get end of line '\n':
                    weight = strip(read_weight(sp))

                    # Getting only the lines with a stable value (with g a the end):
                    # NB: the way read_weight is read should only return stable values now,
                    # but we keep this test just in case.
                    if weight[end] == 'g'
                        date = now()

                        # Parsing the value into a Float64:
                        parsed_value = parse_weight(weight)

                        # Average the value with previous measurements:
                        # if ismissing(weight_value[1])
                        #     # Just for the first measurement
                        #     weight_value[1] = parsed_value
                        # else
                        #     weight_value[1] = mean((weight_value[1], parsed_value))
                        # end
                        weight_value[1] = parsed_value

                        # if (date - date_before[1]).value >= integration_step
                        weight_string = string(Dates.format(date, "yyyy-mm-ddTHH:MM:SS")," ",
                            round(weight_value[1]; digits=3),"\n")
                        weights_file = open(file_path, "a")
                        write(weights_file, weight_string)
                        close(weights_file)
                        println(weight_string)
                        # date_before[1] = date
                        # Reset weight_value to last measurement
                        # weight_value[1] = parsed_value
                        # end
                    end
                end
            catch e
                println("Error in execution of weight measurement: $e")
            end
        end
    catch e
        println("Error in execution of weight measurement, please run the function again: $e")
    finally
        close(sp)
    end
end
