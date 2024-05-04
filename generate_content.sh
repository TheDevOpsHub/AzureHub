#!/bin/bash

# Read services from JSON file and sort them by service name
services=$(jq -r '.services | sort_by(.service_name) | .[] | @base64' az_services.json)

# Get total services count
services_count=$(jq '.services | length' az_services.json)
echo "Total services supported: $services_count"

# Save text below <!-- Learning-Resource-End --> to a temporary file
awk '/<!-- Learning-Resource-End -->/{p=1; next} p' README.md >temp.txt
echo "Save text below <!-- Learning-Resource-End --> to a temporary file"
cat temp.txt

echo ""
echo "Creating new content"
# Clear all text between "<!-- Learning-Resource-Begin -->" and "<!-- Learning-Resource-End -->"
sed -i '/<!-- Learning-Resource-Begin -->/,$d' README.md
# cat README.md

# Append main section header
echo "<!-- Learning-Resource-Begin -->" >>README.md
echo "<!-- Do not edit the above line manually -->" >>README.md
echo "## Azure Services Learning Resources 📘" >>README.md
# Brief introduction
echo "This section provides links to detailed documentation, introduction videos, and FAQs for popular AWS services" >>README.md
echo "- **Total services covered:** **${services_count}**" >>README.md
echo "- **Azure Docs:** Official documentation for each service" >>README.md
echo "- **Azure FAQs:** Frequently asked questions about Azure services" >>README.md

echo "" >>README.md
echo "Full Azure services learning resource table:" >>README.md
echo "" >>README.md
echo "| ID | Service Name | Azure Docs | Azure FAQs |" >>README.md
echo "|----|--------------|----------|----------|" >>README.md

# Initialize ID counter
id=1

# Iterate over each service
for service in $services; do
  # Function to decode base64 and extract value using jq
  _jq() {
    echo ${service} | base64 --decode | jq -r ${1}
  }
  # Extract service details
  service_short_name=$(_jq '.service_short_name')
  url=$(_jq '.service_url')
  service_name=$(_jq '.service_name')
  faq_url=$(_jq '.faq_url')

  # Update the service README.md content
  # echo "| $id | $service_name | 📖 [$service_short_name]($url) | ❔ [$service_short_name/faqs]($faq_url)|" >>README.md
  echo "| $id | $service_name | 📖 [$service_short_name]($url) | ❔ TODO |" >>README.md

  # Increment ID
  ((id++))
done

echo "" >>README.md
echo "And **more upcoming services content...⏩** you can star/follow this repository to get more up-to-dated content ⭐" >>README.md

echo "<!-- Do not edit the below line manually -->" >>README.md
echo "<!-- Learning-Resource-End -->" >>README.md

# Append the saved text back to the end of the file
cat temp.txt >>README.md

# Remove the temporary file
rm temp.txt

echo "Check the new content in README.md"
cat README.md
