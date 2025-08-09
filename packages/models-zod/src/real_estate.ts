import { z } from 'zod';

export const ListingStatus = z.enum(['draft', 'published', 'unpublished', 'sold']);

export const ListingCreate = z.object({
  buildingId: z.string().uuid(),
  apartmentId: z.string().uuid().optional(),
  title: z.string().min(3),
  description: z.string().min(1),
  price: z.number().nonnegative(),
  bedrooms: z.number().int().min(0),
  bathrooms: z.number().int().min(0),
  areaM2: z.number().int().positive().optional(),
});

export const ListingUpdate = z.object({
  title: z.string().min(3).optional(),
  description: z.string().min(1).optional(),
  price: z.number().nonnegative().optional(),
  bedrooms: z.number().int().min(0).optional(),
  bathrooms: z.number().int().min(0).optional(),
  areaM2: z.number().int().positive().optional(),
  status: ListingStatus.optional(),
  publishedAt: z.string().datetime().optional(),
});

export const Listing = ListingCreate.extend({
  id: z.string().uuid(),
  status: ListingStatus,
  publishedAt: z.string().datetime().nullable().optional(),
  createdAt: z.string(),
  updatedAt: z.string(),
});

export const LeadCreate = z.object({
  listingId: z.string().uuid(),
  name: z.string().min(2),
  email: z.string().email(),
  phone: z.string().min(7).optional(),
  message: z.string().max(2000).optional(),
});
