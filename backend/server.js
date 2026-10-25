/**
 * Order backend for the coffee shop app.
 *
 * The Flutter app POSTs the freshly checked-out order here; this service is
 * the trusted party that holds the FCM server credentials and turns the order
 * into the "your order is ready to be prepared" push notification.
 *
 * Credentials come from, in order of preference:
 *   1. SERVICE_ACCOUNT_KEY  — path to a downloaded service-account JSON file
 *   2. GOOGLE_APPLICATION_CREDENTIALS — standard Google ADC wiring
 *   3. gcloud application-default credentials
 * See README.md in this folder for how to produce #1.
 */

const path = require('path');

const admin = require('firebase-admin');
const cors = require('cors');
const express = require('express');

const PORT = Number(process.env.PORT || 8080);

let firebaseError = null;
try {
  const keyPath = process.env.SERVICE_ACCOUNT_KEY;
  if (keyPath) {
    admin.initializeApp({
      credential: admin.credential.cert(require(path.resolve(keyPath))),
    });
  } else {
    // Falls back to GOOGLE_APPLICATION_CREDENTIALS / ADC.
    admin.initializeApp();
  }
} catch (error) {
  firebaseError = error.message;
  console.error(`[startup] Firebase Admin is not configured: ${error.message}`);
}

const app = express();
app.use(cors());
app.use(express.json());

app.get('/health', (_req, res) => {
  res.json({ ok: true, firebase: firebaseError === null });
});

/**
 * POST /api/orders
 * body: { fcmToken, itemCount, totalEgp, items: [{ name, quantity, unitPriceEgp }] }
 */
app.post('/api/orders', async (req, res) => {
  const { fcmToken, items = [], itemCount, totalEgp } = req.body || {};

  if (!fcmToken) {
    return res
      .status(400)
      .json({ ok: false, error: 'fcmToken is required to notify the device' });
  }
  if (firebaseError) {
    return res.status(503).json({
      ok: false,
      error: 'Firebase Admin is not configured — see backend/README.md',
      detail: firebaseError,
    });
  }

  const count = Number(
    itemCount ?? items.reduce((sum, item) => sum + (Number(item.quantity) || 0), 0),
  );
  const total = Number(totalEgp ?? 0);

  const message = {
    token: fcmToken,
    notification: {
      title: 'تم استلام طلبك!',
      body: `طلبك جاهز للتحضير — ${count} منتج · ${total} EGP`,
    },
    data: {
      type: 'order_placed',
      itemCount: String(count),
      totalEgp: String(total),
    },
    android: {
      priority: 'high',
      notification: {
        // Created by the app on startup; matches FcmService.orderChannel.
        channelId: 'order_updates',
        sound: 'default',
        // Light rust accent so the push matches the coffee-shop palette.
        color: '#8C4527',
        tag: 'order_placed',
      },
    },
  };

  try {
    const messageId = await admin.messaging().send(message);
    console.log(`[orders] FCM notification sent (${messageId}) — ${count} item(s), ${total} EGP`);
    return res.json({ ok: true, messageId });
  } catch (error) {
    const code = error?.code || '';
    console.error(`[orders] FCM send failed: ${code} ${error.message}`);

    if (code === 'messaging/registration-token-not-found') {
      return res.status(410).json({
        ok: false,
        error: 'FCM token is stale; the app should fetch a fresh one',
      });
    }
    return res.status(502).json({ ok: false, error: error.message });
  }
});

app.listen(PORT, () => {
  console.log(`Order backend listening on http://0.0.0.0:${PORT}`);
  console.log(`Firebase Admin ready: ${firebaseError === null}`);
});
