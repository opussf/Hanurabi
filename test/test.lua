#!/usr/bin/env lua

require "wowTest"

test.outFileName = "testOut.xml"

-- Figure out how to parse the XML here, until then....

-- require the file to test
package.path = "../src/?.lua;'" .. package.path
require "Hanurabi"

function test.before()
end

function test.after()
end

test.run()