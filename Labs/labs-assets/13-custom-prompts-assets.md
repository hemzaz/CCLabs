# Lab 13 - Prompt Engineering Assets

## The 4 S's of Prompting

- **Single**: Focus on a single task or question at a time.
- **Specific**: Be explicit about what you want. Avoid ambiguity.
- **Short**: Keep it concise but descriptive.
- **Surround**: Open relevant files to provide context.

## Example: `date_formatter.py`

```python
from datetime import datetime

def format_date_germany(date_obj: datetime) -> str:
    """
    Formats a datetime object to a string in German format (DD.MM.YYYY).
    """
    return date_obj.strftime("%d.%m.%Y")

def get_date_format(country_code: str) -> str:
    """
    Returns the date format string for a given country code.
    """
    formats = {
        'US': '%m/%d/%Y',
        'UK': '%d/%m/%Y',
        'ISO': '%Y-%m-%d',
        'DE': '%d.%m.%Y',
        'JP': '%Y/%m/%d'
    }
    return formats.get(country_code, '%Y-%m-%d')
```
