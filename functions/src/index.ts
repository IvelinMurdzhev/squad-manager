import { setGlobalOptions } from 'firebase-functions/v2';

setGlobalOptions({ region: 'europe-west3', maxInstances: 5 });

export { health } from './http/health_function';
