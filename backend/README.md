# Order backend (FCM notifications)

Small Express service that receives the order the app posts at checkout and
pushes the **"تم استلام طلبك — order ready to be prepared"** notification
through Firebase Cloud Messaging.

The app itself never sees the FCM server key: it only holds a device token,
so sending stays here where credentials are safe.

## 1. One-time Firebase setup

The service authenticates with a **service account**. Pick one:

**Option A — download a key (simplest)**

1. Firebase console → ⚙ Project settings → *Service accounts*
2. *Generate new private key* → save the JSON
3. Keep it out of git (`backend/.gitignore` already ignores it):

```bash
# Windows PowerShell
$env:SERVICE_ACCOUNT_KEY = "C:\path\to\serviceAccountKey.json"
```

**Option B — application default credentials**

```bash
gcloud auth application-default login
```

## 2. Run it

```bash
cd backend
npm install
npm start          # listens on http://localhost:8080
```

Smoke test:

```bash
curl http://localhost:8080/health
# {"ok":true,"firebase":true}
```

## 3. Point the app at it

The Flutter side reads `ORDER_API_BASE` (default `http://10.0.2.2:8080`,
which is your machine from the Android emulator):

```bash
# Android emulator (default, nothing to pass)
flutter run

# Physical device on the same Wi-Fi
flutter run --dart-define=ORDER_API_BASE=http://192.168.1.10:8080
```

Cleartext HTTP is enabled for **debug builds only**
(`android/app/src/debug/AndroidManifest.xml`). Deploy the backend behind
HTTPS and drop the `--dart-define` for a release build.

## 4. What the app sends

```json
POST /api/orders
{
  "fcmToken": "eXXXX…",
  "itemCount": 3,
  "totalEgp": 230,
  "items": [
    { "name": "Espresso", "quantity": 2, "unitPriceEgp": 70 },
    { "name": "Latte", "quantity": 1, "unitPriceEgp": 90 }
  ]
}
```

Response: `{ "ok": true, "messageId": "…" }`.

Failures are non-fatal for the app — the checkout dialog has already told the
customer the order went through, so the client logs and moves on.

## Routes

| Method | Path          | Purpose                                  |
|--------|---------------|------------------------------------------|
| GET    | `/health`     | Liveness + whether Firebase is configured |
| POST   | `/api/orders` | Place an order and send the FCM push      |
