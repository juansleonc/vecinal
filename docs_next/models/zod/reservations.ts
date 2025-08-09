import { z } from 'zod';

export const ReservationStatus = z.enum(['pending', 'pre-approved', 'approved', 'cancelled']);

export const ReservationCreate = z.object({
  amenityId: z.string().uuid(),
  date: z.string().regex(/^\d{4}-\d{2}-\d{2}$/),
  timeFrom: z.string().regex(/^([01]\d|2[0-3]):[0-5]\d$/),
  timeTo: z.string().regex(/^([01]\d|2[0-3]):[0-5]\d$/),
  message: z.string().min(1),
});

export const ReservationUpdate = z.object({
  status: ReservationStatus.optional(),
  responsibleId: z.string().uuid().optional(),
}).refine((data) => data.status || data.responsibleId, {
  message: 'Debe actualizar status o responsibleId',
});

export const Reservation = ReservationCreate.extend({
  id: z.string().uuid(),
  reserverId: z.string().uuid(),
  responsibleId: z.string().uuid().optional(),
  status: ReservationStatus,
  createdAt: z.string(),
  updatedAt: z.string(),
});
