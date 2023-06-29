<!DOCTYPE html>
<html>
<head>
    <title>Chat Bot</title>
    <style>
        body {
            font-family: Arial, sans-serif;
        }

        .chat-container {
            max-width: 600px;
            margin: 0 auto;
            padding: 20px;
            box-sizing: border-box;
            background-color: #f5f5f5;
            border-radius: 5px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }

        .chat-container h1 {
            text-align: center;
        }

        .chat-form {
            display: flex;
            margin-bottom: 20px;
        }

        .chat-input {
            flex-grow: 1;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 3px;
            font-size: 16px;
        }

        .chat-button {
            background-color: #4CAF50;
            color: #fff;
            border: none;
            border-radius: 3px;
            padding: 10px 15px;
            font-size: 16px;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        .chat-button:hover {
            background-color: #45a049;
        }

        .chat-conversation {
            margin-bottom: 20px;
        }

        .chat-conversation p {
            margin: 5px 0;
            padding: 5px 10px;
            border-radius: 3px;
            background-color: #fff;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
        }

        .chat-conversation p strong {
            font-weight: bold;
        }
    </style>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        $(document).ready(function() {
            $('#question-form').submit(function(e) {
                e.preventDefault();
                var question = $('#question-input').val();
                $.ajax({
                    url: '/chat',
                    type: 'POST',
                    data: {question: question},
                    success: function(response) {
                        $('#response-text').text(response);
                        $('#conversation').append('<p><strong>Question:</strong> ' + question + '</p>');
                        $('#conversation').append('<p><strong>Answer:</strong> ' + response + '</p>');
                    },
                    error: function(xhr, status, error) {
                        alert('Error: ' + error);
                    }
                });
                $('#question-input').val('');
            });
        });
    </script>
</head>
<body>
    <div class="chat-container">
        <h1>Chat Bot</h1>
        <div class="chat-conversation" id="conversation">
            <h2>Conversation</h2>
        </div>
        <form class="chat-form" id="question-form">
            <input type="text" class="chat-input" id="question-input" placeholder="Enter your question">
            <button type="submit" class="chat-button">Chat</button>
        </form>
        <div id="response">
            <p id="response-text"></p>
        </div>
    </div>
</body>
</html>
