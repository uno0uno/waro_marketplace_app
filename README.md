# WARO Marketplace App

Open local commerce marketplace — Flutter.

**Vision:** An open, free marketplace for local commerce. Free to list, free to discover. No in-app payments or commissions in v1. WARO connects local supply and demand while helping buyers find trusted sellers nearby.

**WARO advantage:** Restaurants and stores already on [warocol.com](https://warocol.com) get boosted exposure (verified badge, prioritized ranking and filters) as paid WARO customers. Anyone can join the marketplace, but WARO clients stand out.

**Trust & compliance:**
- Local regulations compliance (restricted categories, age-gated products, required disclosures)
- AI-powered safety: product/offer screening (counterfeit, prohibited items, misleading claims), image + description moderation, duplicate/spam detection, and risk scoring before publishing
- Buyer protection signals: seller verification, report/flag flow, and transparent offer history

## License

Source-Available Proprietary — see [LICENSE.md](./LICENSE.md) and [NOTICE.md](./NOTICE.md).
Same license as `WARO COLOMBIA/front_nuxt`. Publicly visible for review, not open source. Commercial/production use requires written license from WARO Colombia.

## Stack

Flutter 3.x + Dart 3.x (once Flutter SDK is installed):

```bash
flutter create . --org com.warocol --project-name waro_marketplace_app
flutter pub get
flutter run
```

## Planned structure

```
lib/
  core/        # config, theme, constants, compliance rules
  features/
    feed/      # marketplace feed, search, filters
    store/     # seller/store profile
    product/   # product/offer detail
    trust/     # AI moderation, verification, reports
  data/        # warocol.com API client (read-only sync)
  widgets/     # shared UI
```

## Roadmap

1. Flutter scaffold + WARO theme
2. Marketplace feed (stores + products)
3. Store/product detail + deep-link to warocol.com
4. Verified WARO badge + ranking boost
5. Search, categories, and local filters
6. AI moderation pipeline (pre-publish checks)
7. Compliance & reporting flows

## Flutter requirements

Install Flutter SDK: https://docs.flutter.dev/get-started/install/macos
`flutter doctor` should pass before `flutter create`.
