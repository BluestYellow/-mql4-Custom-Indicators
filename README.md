<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Custom Indicators for MetaTrader 4</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            line-height: 1.6;
            margin: 20px;
            color: #333;
        }
        h1, h2 {
            color: #2C3E50;
        }
        h1 {
            text-align: center;
            border-bottom: 3px solid #3498DB;
            padding-bottom: 10px;
        }
        .content {
            max-width: 800px;
            margin: 0 auto;
        }
        .section {
            margin-bottom: 30px;
        }
        ul {
            padding-left: 20px;
        }
        li {
            margin-bottom: 10px;
        }
        .button {
            display: inline-block;
            padding: 10px 15px;
            margin: 10px 0;
            color: #fff;
            background-color: #3498DB;
            text-decoration: none;
            border-radius: 5px;
        }
        .button:hover {
            background-color: #2980B9;
        }
        pre {
            background: #f4f4f4;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            overflow-x: auto;
        }
        .footer {
            text-align: center;
            margin-top: 50px;
            font-size: 0.9em;
            color: #7F8C8D;
        }
        .highlight {
            background-color: #ECF0F1;
            padding: 5px;
            border-radius: 3px;
        }
    </style>
</head>
<body>
    <div class="content">
        <h1>📊 Custom Indicators for MetaTrader 4</h1>

        <div class="section">
            <p>Welcome to the repository of <strong>Custom Indicators for the MetaTrader 4</strong> platform. This project aims to make life easier for traders and developers by offering useful tools and open-source code to enhance your analysis and improve trading strategies. I hope you find valuable resources here for your journey in the financial markets.</p>
        </div>

        <div class="section">
            <h2>🛠️ Repository Content</h2>
            <ul>
                <li><strong>Dragon Trend Indicator.mq4</strong>: An indicator that identifies market trends using a robust approach based on the Dragon method.</li>
                <li><strong>MA Distance Finder.mq4</strong>: A tool to calculate the distance between the current price and the selected moving average, providing valuable info for risk management.</li>
                <li><strong>Simple 3MA Visualization.mq4</strong>: Simple visualization of three moving averages to identify crossovers and key reversal points.</li>
                <li><strong>ProjectX.mq4 <span class="highlight">(under development)</span></strong>: An innovative indicator that identifies market trends by analyzing the relative positions of moving averages calculated from high, low, and close prices. It displays the current trend direction directly on the chart and provides a control panel for enhanced visualization.</li>
                <li><strong>Utils.mqh</strong>: Utility function library that helps in the development and simplifies the creation of new indicators.</li>
            </ul>
        </div>

        <div class="section">
            <h2>🚀 How to Use</h2>
            <ol>
                <li><strong>Clone the Repository:</strong>
                    <pre>git clone https://github.com/BluestYellow/-mql4-Custom-Indicators.git</pre>
                </li>
                <li><strong>Copy the Files:</strong>
                    <p>Move the <code>.mq4</code> files to the <strong>Indicators</strong> folder in your MetaTrader 4 data directory. To access it, in MetaTrader 4, click on <span class="highlight">"File" > "Open Data Folder" > <code>MQL4</code> > <code>Indicators</code></span>.</p>
                </li>
                <li><strong>Compile the Indicators:</strong>
                    <p>Open MetaEditor, locate the copied files, and compile them to make them available in MetaTrader 4. Just right-click on the file and choose <span class="highlight">"Compile"</span>.</p>
                </li>
                <li><strong>Add to Chart:</strong>
                    <p>In MetaTrader 4, open the "Navigator" tab, find the indicator under "Custom Indicators," and drag it onto the chart you want to analyze.</p>
                </li>
            </ol>
        </div>

        <div class="section">
            <h2>🤖 Contributions</h2>
            <p>If you find any issues or have suggestions for improvements, feel free to open an <strong>issue</strong>. Pull requests are also super welcome — the more we collaborate, the better the tools get.</p>
        </div>

        <div class="section">
            <h2>📃 License</h2>
            <p>This project is licensed under the <strong>MIT License</strong>, allowing for freedom of use and modification. Check out the <a href="LICENSE.md" class="button">LICENSE.md</a> file for more details.</p>
        </div>

        <div class="section">
            <h2>📩 Contact</h2>
            <p>If you have any questions, suggestions, or just want to share your experiences with the indicators, reach out to me on Telegram: <a href="https://t.me/BlueXInd" class="button">@BlueXInd</a>.</p>
        </div>

        <div class="footer">
            <p>Thanks for using and contributing to this project! Hope it’s useful and brings valuable insights to your trades. Happy trading! 🌱🚀</p>
        </div>
    </div>
</body>
</html>
