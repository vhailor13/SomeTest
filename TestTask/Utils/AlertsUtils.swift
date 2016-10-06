
import UIKit

func error(code code: Int,  message: String) -> NSError {
    return NSError(domain: "com.testtask", code: code, userInfo: [NSLocalizedDescriptionKey: message])
}
