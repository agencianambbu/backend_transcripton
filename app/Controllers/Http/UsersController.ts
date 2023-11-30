import type { HttpContextContract } from '@ioc:Adonis/Core/HttpContext'
import User from 'App/Models/User'
import { schema, rules } from '@ioc:Adonis/Core/Validator'


export default class UsersController {

  public async register({ request, response, auth }: HttpContextContract) {
    const userSchema = schema.create({
      email: schema.string({ trim: true }, [rules.email(), rules.unique({ table: 'users', column: 'email', caseInsensitive: true })]),
      password: schema.string({}, [rules.minLength(4)]),
      confirmPassword: schema.string({}, [rules.minLength(4)])
    })

    const {email, password, confirmPassword} = await request.validate({ schema: userSchema })
    
    if(password !== confirmPassword){
      return response.status(400).json({message: 'Password and ConfirmPassword must be equals'})
    }

    const user = await User.create({email, password})

    const token = await auth.use('api').generate(user)

    return response.json({ user, token })

  }
}