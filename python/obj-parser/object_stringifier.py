import demjson3
import json
import re

# Step 1: Read JS-style config from file
with open("input-parse-file.txt", "r") as f:
    raw = f.read().strip()

# Step 2: Wrap with braces if needed
if not raw.startswith("{"):
    raw = "{" + raw
if not raw.endswith("}"):
    raw = raw + "}"

# Step 3: Remove text inside parentheses
raw = re.sub(r'\([^)]*\)', '', raw)

# Step 4: Convert to Python object using demjson3
try:
    js_object = demjson3.decode(raw)
except demjson3.JSONDecodeError as e:
    print(f"❌ Failed to parse config: {e}")
    exit(1)

# Step 5: Create the output dictionary by stringifying each top-level key's value
output = {
    key: json.dumps(value)
    for key, value in js_object.items()
}

# Step 6: Save to file
with open("parsed_config_output.json", "w") as f:
    json.dump(output, f, indent=2)

print("✅ Saved with all top-level keys stringified in JSON")
