
OpenAI.configure do |config|
  config.access_token = ENV['OPEN_ROUTER_ACCESS_TOKEN']
  config.uri_base = "https://openrouter.ai/api/v1"
end

client = OpenAISwarm.new

def get_weather(location:)
  # Simulate fetching weather data
  "{'temp':67, 'unit':'F'}"
end

# func =  Proc.new { get_weather }
# func.call.method(:get_weather).parameters
# => ArgumentError (missing keyword: :location)

# func = Proc.new { |location| get_weather(location: location) }
# func.call.method(:get_weather).parameters

function_instance = OpenAISwarm::Transfer.new(
  transfer_agent: Proc.new { |location| get_weather(location: location) },
  transfer_name: 'get_weather',
  description: ''
)

agent = OpenAISwarm::Agent.new(
  name: "Agent",
  instructions: "You are a helpful agent.",
  model: "gpt-4o-mini",
  functions: [function_instance]
)
# debugger logger: {:model=>"gpt-4o-mini", :messages=>[{:role=>"system", :content=>"You are a helpful agent."}, {"role"=>"user", "content"=>"What's the weather in NYC?"}], :tools=>[{:type=>"function", :function=>{:name=>"get_weather", :description=>"", :parameters=>{:type=>"object", :properties=>{:location=>{:type=>"string"}}, :required=>["location"]}}}], :stream=>false, :parallel_tool_calls=>true}
response = client.run(
  messages: [{"role" => "user", "content" => "What's the weather in NYC?"}],
  agent: agent,
  debug: true,
)

# print(response.messages[-1]["content"])
# The current temperature in New York City is 67°F. => nil