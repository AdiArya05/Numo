# Numo Visual Direction

Numo should feel like a premium, iPhone-first money tracker: calm, dark, tactile, and fast. The product should borrow the confidence and polish from modern wallet apps, but the actual experience should be simpler and more personal: logging money, understanding patterns, reviewing recurring payments, and keeping everything private.

Working tagline: Money, made clear.

## Product Feel

Numo should feel:

- Native to iPhone, not like a web dashboard inside a phone.
- Dark by default, with soft charcoal surfaces and high-contrast white text.
- Premium but not crypto-like.
- Personal and calm, not gamified or loud.
- Fast to log with one thumb.
- Trustworthy enough for private financial data.

The key emotional idea:

Numo is not a banking app. It is the private place where your money life becomes understandable.

## Reference Takeaways

### Keep

- Large bold page titles such as Overview and History.
- Floating pill navigation at the bottom.
- Large circular add button as a primary action.
- Dark empty states with simple icons and direct calls to action.
- Bottom-sheet style add flows.
- Search and filter controls grouped into rounded capsules.
- Month/calendar history view with daily transaction markers.
- Big money totals as the visual anchor.
- Soft shadows, blurred background overlays, and layered sheets.
- Clear distinction between income and expense actions.
- A premium AI Log action that feels special.

### Adapt

- Fuse's wallet language should become personal finance language.
- "Receive", "Send", and "Swap" should become "Income", "Expense", and "AI Log".
- "Paid with" should support Apple Pay, card, cash, PayNow, bank transfer, and manual.
- "Sign in to backup" should become optional iCloud backup/security messaging.
- "Go Pro" can be deferred. The first version should focus on trust and usefulness.
- The receipt-style add screen is visually strong, but Numo should make it faster and less decorative.

### Avoid

- Crypto wallet terminology.
- NFT/investment modules in the core experience.
- Overly busy settings pages.
- Too many promotional cards early in the app.
- Light mode as the primary design direction.
- Copying the receipt UI too literally if it slows down entry.

## Visual System

### Color

Primary background:

- `#111111` app background
- `#1C1C1E` elevated background
- `#2C2C2E` card surface
- `#3A3A3C` controls and pressed states

Text:

- `#FFFFFF` primary
- `#B8B8BE` secondary
- `#6F6F78` muted

Accent colors:

- Expense: `#FF6B5F`
- Income: `#35D07F`
- AI Log: iridescent gradient or soft lilac/blue highlight
- Calendar marker: `#2F9BFF`
- Warning/security: `#FF7A59`

Numo should not become a one-color app. The base should be neutral charcoal, with color only used for meaning.

### Typography

Use SF Pro through native SwiftUI.

- Large page title: bold, 44-56 pt depending on screen.
- Main number: bold, 56-72 pt.
- Card title: semibold, 18-22 pt.
- Body: regular, 16-18 pt.
- Metadata: medium, 13-15 pt.

Use large type only for true screen anchors. Compact cards should stay tight and readable.

### Shape

- Bottom nav pill: large capsule.
- Floating add button: 72-84 pt circle.
- Cards: 28-36 pt corner radius for large mobile panels.
- Small controls: capsules.
- Sheets: top-rounded, full-width, drag handle.

### Motion

- Add menu expands from the floating plus with background blur.
- AI Log orb gently glows or pulses when selected.
- Bottom sheets should slide from bottom with native spring motion.
- Calendar month changes should use horizontal movement.
- App lock/unlock should fade through privacy blur.

## Core Navigation

Primary bottom navigation:

- Overview
- History
- Floating add button

Secondary destinations:

- Recurring
- Needs Review
- Settings/Security
- Apple Pay Shortcut Setup

The app should not need a full tab bar at first. Numo can feel more focused with two main spaces and a powerful add action.

## First Screen Set

### 1. Overview

Purpose: show where money stands this week or month.

Primary content:

- Header: "Overview"
- Greeting: "Good day, Adi"
- Period control: Weekly / Monthly
- Date range with previous/next controls
- Main card: Expense vs Income
- Secondary card: Total expenditure
- Secondary card: Recurring this week
- Optional card: Needs review if there are imported or uncertain transactions

Empty state:

- Title: "Nothing here yet"
- CTA: "Tap to add your first transaction"

When data exists:

- Expense total
- Income total
- Net difference
- Simple bar or ring chart
- Top categories
- Recent transactions

### 2. History

Purpose: browse, search, and understand past transactions.

Primary content:

- Header: "History"
- Search/filter capsule
- Month chips: View all, This month, May 2026, Apr 2026
- Month total
- Calendar grid
- Transaction list grouped by day

Calendar behavior:

- Income days get small green labels such as "+1.2K".
- Expense days get small red labels such as "-24".
- Mixed days get a neutral dot plus net amount.
- Tapping a date filters the list below.

Search state:

- Search bar remains near top.
- Keyboard pushes content only as needed.
- Cancel or close button appears as a circular control.

### 3. Add Menu

Purpose: make logging feel instant.

Appears after tapping floating plus.

Actions:

- Income
- Expense
- AI Log

Treatment:

- Background blur/dim.
- Income uses green plus.
- Expense uses red minus.
- AI Log uses premium glowing orb.

This is the signature Numo interaction.

### 4. Manual Add Transaction

Purpose: fast structured entry for income or expense.

Recommended layout:

- Bottom sheet with drag handle.
- Header: Income or Expense with selector.
- Close button left.
- Save/check button right.
- Amount as the primary field.
- Currency chip: SGD.
- Optional note or title.
- Category row.
- Paid with row.
- Date row.
- Recurring toggle.

The receipt-style card is visually memorable, but the first version should optimize for speed. Use its mood, not all of its ornamentation.

### 5. AI Log

Purpose: let the user log naturally.

Entry examples:

- "Coffee at Starbucks 6.80 with Apple Pay"
- "Salary 1200 came in today"
- "Paid 14.50 for Grab yesterday"
- "Netflix 17.98 monthly"

Screen structure:

- Large input field.
- Voice button.
- Suggested parsed transaction preview.
- Confirm button.
- Needs Review state if category/date/payment method is uncertain.

AI Log should be more than a text box. It should feel like Numo understands messy real life.

### 6. Recurring

Purpose: track predictable money movement.

Primary content:

- Upcoming this week.
- Income recurring.
- Expense recurring.
- Monthly expected inflow/outflow.
- Reminders and missed confirmation states.

Recurring items:

- Salary
- Rent
- Subscriptions
- Phone bill
- Insurance
- Allowance

### 7. Settings/Security

Purpose: build trust.

Sections:

- Security
- Wallets and payment methods
- Apple Pay Shortcut setup
- iCloud backup
- Export data
- Notifications
- Categories
- About Numo

Security rows:

- Face ID lock
- Privacy blur in app switcher
- Local data encryption
- Backup status

Avoid generic wallet settings like NFTs, address book, or crypto tokens.

## Numo-Specific Details

### Apple Pay

Apple Pay should be framed as "Shortcut logging", not automatic bank sync.

Screen copy:

- "Set up Apple Pay logging"
- "Use Shortcuts to send transaction details into Numo after a payment."
- "Numo never asks for bank credentials."

### PayNow

PayNow should be handled as:

- AI Log text entry
- screenshot/OCR later
- manual confirmation
- statement import later
- share extension later

Payment method options:

- Apple Pay
- PayNow
- Card
- Bank transfer
- Cash
- Other

### Needs Review

Use this queue for uncertain imported or AI-parsed transactions.

Examples:

- Missing category
- Unknown payment method
- Duplicate suspicion
- Unclear merchant from screenshot/import

## First Figma Direction

Start with these frames:

1. Overview empty
2. Overview with sample data
3. History calendar with sample salary
4. Add action menu
5. Add expense sheet
6. AI Log input and parsed preview
7. Recurring overview
8. Settings/Security
9. Apple Pay Shortcut setup
10. Needs Review queue

Recommended device:

- iPhone 15 Pro / iPhone 16 Pro size
- Dark mode first
- Use realistic Singapore examples in SGD

## Sample Demo Data

User:

- Name: Adi
- Currency: SGD

Transactions:

- Salary, +SGD 1,200.00, Debit Card, Jun 13, Income
- Starbucks, -SGD 6.80, Apple Pay, Jun 23, Food & Drinks
- Grab, -SGD 14.50, PayNow, Jun 22, Transport
- Netflix, -SGD 17.98, Card, recurring monthly, Subscriptions
- Rent, -SGD 850.00, Bank Transfer, recurring monthly, Housing

Categories:

- Food & Drinks
- Transport
- Shopping
- Housing
- Subscriptions
- Health
- Education
- Salary
- Other

## Design Principle

Every screen should answer one question:

- Overview: "How am I doing?"
- History: "Where did my money go?"
- Add: "What happened?"
- AI Log: "Can I say it naturally?"
- Recurring: "What is coming again?"
- Settings: "Is this private and under my control?"

