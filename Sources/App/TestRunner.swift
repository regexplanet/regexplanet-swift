import Foundation

func RunTest(_ testInput: TestInput) -> TestOutput {

    if testInput.regex == nil || testInput.regex == "" {
        return TestOutput(success: false, html: nil, message: "No regular expression to test!")
    }

    let regexStr = testInput.regex ?? ""
    let replacement = testInput.replacement ?? ""

    var html = String()
    html += "<table class=\"table table-bordered table-striped\" style=\"width:auto;\">"
    html += "<tbody>"
    html += "<tr>"
    html += "<td>Regular Expression</td>"
    html += "<td>\(escapeHtml(regexStr))</td>"
    html += "</tr>"
    if replacement != "" {
        html += "<tr>"
        html += "<td>Replacement</td>"
        html += "<td>\(escapeHtml(replacement))</td>"
        html += "</tr>"
    }
    html += "</tbody>"
    html += "</table>"

    do {
        _ = try Regex(regexStr)
    } catch {
        return TestOutput(success: false, html: html, message: "Invalid regular expression! Error: \(error.localizedDescription)")
    }

    let regex = try! Regex(regexStr)

    if testInput.input == nil || testInput.input!.count == 0 {
        return TestOutput(success: false, html: html, message: nil)
    }

    html += "<table class=\"table table-bordered table-striped\" style=\"width:auto;\">"
    html += "<thead>"
    html += "<tr>"
    html += "<th>Test</th>"
    html += "<th>Target String</th>"
    html += "<th>contains</th>"
    html += "<th>replacingOccurrences</th>"
    html += "<th>wholeMatch</th>"
    html += "</tr>"
    html += "</thead>"
    html += "<tbody>"
    var testIndex = 0;
    for input in testInput.input! {
        testIndex += 1
        if input == "" {
            continue
        }
        let contains = input.contains(regexStr)
        let replace = input.replacingOccurrences(of: regexStr, with: replacement, options: testInput.option?.contains("i") == true ? .caseInsensitive : [])
        let wholeMatch = input.wholeMatch(of: regex);
        let wholeMatchStr = wholeMatch == nil ? "<i>nil</i>" : escapeHtml("\(wholeMatch)");
        html += "<tr>"
        html += "<td class=\"text-center\">\(testIndex)</td>"
        html += "<td>\(escapeHtml(input))</td>"
        html += "<td>\(contains ? "yes" : "no")</td>"
        html += "<td>\(escapeHtml(replace))</td>"
        html += "<td>\(wholeMatchStr)</td>"
        html += "</tr>"
    }
    html += "</tbody>"
    html += "</table>"

    return TestOutput(success: true, html: html, message: nil)
}

import Foundation

func escapeHtml(_ input: String) -> String {
    var escapedString = input
    escapedString = escapedString.replacingOccurrences(of: "&", with: "&amp;")
    escapedString = escapedString.replacingOccurrences(of: "<", with: "&lt;")
    escapedString = escapedString.replacingOccurrences(of: ">", with: "&gt;")
    return escapedString
}