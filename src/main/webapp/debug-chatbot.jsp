<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Debug Chatbot API</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>

<body class="bg-gray-50 min-h-screen p-8">
    <div class="max-w-4xl mx-auto">
        <h1 class="text-3xl font-bold text-gray-900 mb-6">🐛 Debug Chatbot API</h1>
        
        <div class="bg-white rounded-lg shadow p-6 mb-6">
            <h2 class="text-xl font-semibold mb-4">Test Different Request Methods</h2>
            
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <!-- Form Data Test -->
                <div class="border rounded-lg p-4">
                    <h3 class="font-medium mb-3">1. Form Data (Current Method)</h3>
                    <button onclick="testFormData()" class="w-full bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600">
                        Test Form Data
                    </button>
                    <div id="formDataResult" class="mt-3 text-sm"></div>
                </div>
                
                <!-- JSON Test -->
                <div class="border rounded-lg p-4">
                    <h3 class="font-medium mb-3">2. JSON Request</h3>
                    <button onclick="testJSON()" class="w-full bg-green-500 text-white px-4 py-2 rounded hover:bg-green-600">
                        Test JSON
                    </button>
                    <div id="jsonResult" class="mt-3 text-sm"></div>
                </div>
                
                <!-- URL Encoded Test -->
                <div class="border rounded-lg p-4">
                    <h3 class="font-medium mb-3">3. URL Encoded</h3>
                    <button onclick="testURLEncoded()" class="w-full bg-purple-500 text-white px-4 py-2 rounded hover:bg-purple-600">
                        Test URL Encoded
                    </button>
                    <div id="urlEncodedResult" class="mt-3 text-sm"></div>
                </div>
                
                <!-- Health Check -->
                <div class="border rounded-lg p-4">
                    <h3 class="font-medium mb-3">4. Health Check</h3>
                    <button onclick="testHealth()" class="w-full bg-yellow-500 text-white px-4 py-2 rounded hover:bg-yellow-600">
                        Test Health
                    </button>
                    <div id="healthResult" class="mt-3 text-sm"></div>
                </div>
            </div>
        </div>
        
        <div class="bg-white rounded-lg shadow p-6">
            <h2 class="text-xl font-semibold mb-4">Manual Test Form</h2>
            
            <form id="manualTestForm" class="space-y-4">
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Test Message:</label>
                    <input type="text" id="testMessage" value="Hello, this is a test message" 
                           class="w-full px-3 py-2 border border-gray-300 rounded-md focus:ring-2 focus:ring-blue-500 focus:border-blue-500">
                </div>
                
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Request Method:</label>
                    <select id="requestMethod" class="w-full px-3 py-2 border border-gray-300 rounded-md focus:ring-2 focus:ring-blue-500 focus:border-blue-500">
                        <option value="formdata">FormData (multipart/form-data)</option>
                        <option value="json">JSON (application/json)</option>
                        <option value="urlencoded">URL Encoded (application/x-www-form-urlencoded)</option>
                    </select>
                </div>
                
                <button type="submit" class="w-full bg-indigo-500 text-white px-4 py-2 rounded hover:bg-indigo-600">
                    Send Test Request
                </button>
            </form>
            
            <div id="manualTestResult" class="mt-4"></div>
        </div>
    </div>

    <script>
        const API_ENDPOINT = '${pageContext.request.contextPath}/api/chat';
        
        // Test Form Data
        async function testFormData() {
            const resultDiv = document.getElementById('formDataResult');
            resultDiv.innerHTML = '<p class="text-blue-600">Testing...</p>';
            
            try {
                const formData = new FormData();
                formData.append('message', 'Test message using FormData');
                
                const response = await fetch(API_ENDPOINT, {
                    method: 'POST',
                    body: formData
                });
                
                const data = await response.json();
                
                if (response.ok) {
                    resultDiv.innerHTML = `<div class="p-2 bg-green-50 text-green-800 rounded">
                        <p>✅ Success</p>
                        <p class="text-xs mt-1">Response: ${data.response ? data.response.substring(0, 50) + '...' : 'No response'}</p>
                    </div>`;
                } else {
                    resultDiv.innerHTML = `<div class="p-2 bg-red-50 text-red-800 rounded">
                        <p>❌ Error ${response.status}</p>
                        <p class="text-xs mt-1">${data.error || 'Unknown error'}</p>
                    </div>`;
                }
            } catch (error) {
                resultDiv.innerHTML = `<div class="p-2 bg-red-50 text-red-800 rounded">
                    <p>❌ Network Error</p>
                    <p class="text-xs mt-1">${error.message}</p>
                </div>`;
            }
        }
        
        // Test JSON
        async function testJSON() {
            const resultDiv = document.getElementById('jsonResult');
            resultDiv.innerHTML = '<p class="text-blue-600">Testing...</p>';
            
            try {
                const response = await fetch(API_ENDPOINT, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({
                        message: 'Test message using JSON'
                    })
                });
                
                const data = await response.json();
                
                if (response.ok) {
                    resultDiv.innerHTML = `<div class="p-2 bg-green-50 text-green-800 rounded">
                        <p>✅ Success</p>
                        <p class="text-xs mt-1">Response: ${data.response ? data.response.substring(0, 50) + '...' : 'No response'}</p>
                    </div>`;
                } else {
                    resultDiv.innerHTML = `<div class="p-2 bg-red-50 text-red-800 rounded">
                        <p>❌ Error ${response.status}</p>
                        <p class="text-xs mt-1">${data.error || 'Unknown error'}</p>
                    </div>`;
                }
            } catch (error) {
                resultDiv.innerHTML = `<div class="p-2 bg-red-50 text-red-800 rounded">
                    <p>❌ Network Error</p>
                    <p class="text-xs mt-1">${error.message}</p>
                </div>`;
            }
        }
        
        // Test URL Encoded
        async function testURLEncoded() {
            const resultDiv = document.getElementById('urlEncodedResult');
            resultDiv.innerHTML = '<p class="text-blue-600">Testing...</p>';
            
            try {
                const params = new URLSearchParams();
                params.append('message', 'Test message using URL encoded');
                
                const response = await fetch(API_ENDPOINT, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded'
                    },
                    body: params
                });
                
                const data = await response.json();
                
                if (response.ok) {
                    resultDiv.innerHTML = `<div class="p-2 bg-green-50 text-green-800 rounded">
                        <p>✅ Success</p>
                        <p class="text-xs mt-1">Response: ${data.response ? data.response.substring(0, 50) + '...' : 'No response'}</p>
                    </div>`;
                } else {
                    resultDiv.innerHTML = `<div class="p-2 bg-red-50 text-red-800 rounded">
                        <p>❌ Error ${response.status}</p>
                        <p class="text-xs mt-1">${data.error || 'Unknown error'}</p>
                    </div>`;
                }
            } catch (error) {
                resultDiv.innerHTML = `<div class="p-2 bg-red-50 text-red-800 rounded">
                    <p>❌ Network Error</p>
                    <p class="text-xs mt-1">${error.message}</p>
                </div>`;
            }
        }
        
        // Test Health Check
        async function testHealth() {
            const resultDiv = document.getElementById('healthResult');
            resultDiv.innerHTML = '<p class="text-blue-600">Testing...</p>';
            
            try {
                const response = await fetch(API_ENDPOINT + '?action=health');
                const data = await response.json();
                
                if (response.ok) {
                    resultDiv.innerHTML = `<div class="p-2 bg-green-50 text-green-800 rounded">
                        <p>✅ Health Check OK</p>
                        <p class="text-xs mt-1">Status: ${data.healthy ? 'Healthy' : 'Unhealthy'}</p>
                    </div>`;
                } else {
                    resultDiv.innerHTML = `<div class="p-2 bg-red-50 text-red-800 rounded">
                        <p>❌ Health Check Failed</p>
                        <p class="text-xs mt-1">${data.error || 'Unknown error'}</p>
                    </div>`;
                }
            } catch (error) {
                resultDiv.innerHTML = `<div class="p-2 bg-red-50 text-red-800 rounded">
                    <p>❌ Network Error</p>
                    <p class="text-xs mt-1">${error.message}</p>
                </div>`;
            }
        }
        
        // Manual test form
        document.getElementById('manualTestForm').addEventListener('submit', async function(e) {
            e.preventDefault();
            
            const message = document.getElementById('testMessage').value;
            const method = document.getElementById('requestMethod').value;
            const resultDiv = document.getElementById('manualTestResult');
            
            resultDiv.innerHTML = '<p class="text-blue-600">Sending request...</p>';
            
            try {
                let requestOptions = {
                    method: 'POST'
                };
                
                if (method === 'formdata') {
                    const formData = new FormData();
                    formData.append('message', message);
                    requestOptions.body = formData;
                } else if (method === 'json') {
                    requestOptions.headers = { 'Content-Type': 'application/json' };
                    requestOptions.body = JSON.stringify({ message: message });
                } else if (method === 'urlencoded') {
                    const params = new URLSearchParams();
                    params.append('message', message);
                    requestOptions.headers = { 'Content-Type': 'application/x-www-form-urlencoded' };
                    requestOptions.body = params;
                }
                
                const response = await fetch(API_ENDPOINT, requestOptions);
                const data = await response.json();
                
                if (response.ok) {
                    resultDiv.innerHTML = `<div class="p-3 bg-green-50 text-green-800 rounded">
                        <h4 class="font-medium">✅ Success</h4>
                        <p class="text-sm mt-1"><strong>Method:</strong> ${method}</p>
                        <p class="text-sm"><strong>Status:</strong> ${response.status}</p>
                        <p class="text-sm"><strong>Response:</strong> ${data.response || 'No response'}</p>
                        <p class="text-sm"><strong>Session ID:</strong> ${data.sessionId || 'None'}</p>
                    </div>`;
                } else {
                    resultDiv.innerHTML = `<div class="p-3 bg-red-50 text-red-800 rounded">
                        <h4 class="font-medium">❌ Error ${response.status}</h4>
                        <p class="text-sm mt-1"><strong>Method:</strong> ${method}</p>
                        <p class="text-sm"><strong>Error:</strong> ${data.error || 'Unknown error'}</p>
                    </div>`;
                }
            } catch (error) {
                resultDiv.innerHTML = `<div class="p-3 bg-red-50 text-red-800 rounded">
                    <h4 class="font-medium">❌ Network Error</h4>
                    <p class="text-sm mt-1"><strong>Method:</strong> ${method}</p>
                    <p class="text-sm"><strong>Error:</strong> ${error.message}</p>
                </div>`;
            }
        });
    </script>
</body>
</html>
