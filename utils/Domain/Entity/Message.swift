import Foundation

enum MessageState {
    case loading
    case error
    case success
    case file
}

struct MessageContent {
    enum MessageType {
        case text
        case code
    }
    var text: String
    var type: MessageType
}

class Message: Identifiable, Equatable {
    static func == (lhs: Message, rhs: Message) -> Bool {
        lhs.id == rhs.id
    }

    let id = UUID()
    var isSentByUser: Bool
    var state: MessageState
    var role: String = ""
    var createdAt: Date = Date()
    var content: String? = ""
    var contents: [MessageContent] = []
    var filename: String? = ""
    var isFile: Bool = false

    init(role: String, content: String){
        self.role = role
        self.content = content
        state = .success
        isSentByUser = false
    }

    init(role: String,
         isSentByUser: Bool,
         state: MessageState,
         createdAt: Date = Date(),
         content: String,
         filename: String? = "",
         isFile: Bool = false){
        self.isSentByUser = isSentByUser
        self.state = state
        self.role = role
        self.content = content
        self.filename = filename
        self.state = isFile ? .file : self.state
        self.isFile = isFile
    }

    /// Error init
    init(error: String) {
        self.role = "assistant"
        self.isSentByUser = false
        self.state =  .error
        self.content = error
        self.isFile = false
    }

    /// Loading init
    init() {
        self.role = "assistant"
        self.isSentByUser = false
        self.state =  .loading
        self.content = ""
        self.isFile = false
    }

    static var loading: Message {
        var message = Message()
        message.isSentByUser = false
        message.state = .loading
        return message
    }

    static var new: Message {
        var message = Message()
        message.isSentByUser = true
        message.state = .success
        return message
    }

    func getString(_ string: String,
                   between start: String,
                   and end: String) -> String? {
        guard let startIndex = string.range(of: start)?.upperBound else {
            return nil
        }
        guard let endIndex = string.range(of: end, range: startIndex..<string.endIndex)?.lowerBound else {
            return nil
        }
        let substring = string.substring(with: startIndex..<endIndex)
        return substring
    }

    func evaluate(this text: String){
        let tokens = text.split(separator: "```")
        for (index, token) in tokens.enumerated() {
            contents.append(MessageContent(text: String(token),
                                           type: index % 2 == 0 ? .text : .code))
        }
    }
}
