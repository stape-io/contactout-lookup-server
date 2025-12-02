# ContactOut Lookup Variable for Google Tag Manager Server Container


This Google Tag Manager Server-Side variable allows you to retrieve contact information using the ContacOut API. It supports enriching user profiles, verifying emails, and retrieving contact details via LinkedIn URLs.

## Features

- **Multiple API Support**: Choose between [People Enrich API](https://api.contactout.com/#people-enrich-api), [Contact Info API - Single](https://api.contactout.com/#contact-info-api-single), and [Email Verifier API](https://api.contactout.com/#email-verifier).
- **Built-in Caching**: Automatically stores API responses in Template Storage to save API credits and reduce latency (defaults to 12 hours).
- **Flexible Output**: Return the full JSON object, a specific key, or a custom flat/nested JSON object.
- **BigQuery Logging**: Native support for logging request and response data to BigQuery.

## Configuration

### 1. API Lookup Configuration

- **Choose ContactOut API**: Select the specific endpoint you wish to use.
- **API Key**: Enter your ContactOut API Key found in your API Dashboard.
- **Store response in cache**: Enable to cache results. You can define the **Cache Expiration Time** (in hours).
- **Extract keys**: Option to parse the JSON response and return specific values (supports dot notation like `foo.bar`).

### 2. API Specific Settings

#### Contact Info - Single

Retrieves contact info based on a LinkedIn profile.

- **Linkedin Profile**: Full URL (e.g., `https://www.linkedin.com/in/...`).
- **Email Type**: Filter by Personal, Work, Both, or None.
- **Include Phone**: Checkbox to request phone number data.

#### Email Verifier

Verifies the deliverability of an email address.

- **Email Address**: The string to verify.

#### People Enrich

Enriches a profile based on provided identifiers. You must provide **one** of the following combinations:

1.  **Primary**: LinkedIn URL, Email, or Phone.
2.  **Name + Secondary**: Full Name (or First/Last) combined with Company, Domain, Education, Location, or Job Title.

### 3. Logging Settings

- **Logs Settings**: Control console logging (No, Debug, or Always).
- **BigQuery Logs**: Enable to stream request data to a BigQuery table.
  - **Project ID**: Google Cloud Project ID (optional, defaults to environment).
  - **Dataset ID**: Target Dataset.
  - **Table ID**: Target Table.

## Permissions

This template requires the following permissions:

- **Send HTTP Requests**: To `https://api.contactout.com/`.
- **Access Template Storage**: For caching responses.
- **Access BigQuery**: If BigQuery logging is enabled.

---

## Open Source

The **ContactOut Lookup Variable by Stape** is developed and maintained by the [Stape Team](https://stape.io/) under the Apache 2.0 license.
